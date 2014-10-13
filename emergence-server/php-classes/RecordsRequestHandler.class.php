<?php

abstract class RecordsRequestHandler extends RequestHandler
{
    // configurables
    static public $recordClass;
    static public $accountLevelRead = false;
    static public $accountLevelComment = 'User';
    static public $accountLevelBrowse = 'Staff';
    static public $accountLevelWrite = 'Staff';
    static public $accountLevelAPI = false;
    static public $browseOrder = false;
    static public $browseConditions = false;
    static public $browseLimitDefault = false;
    static public $editableFields = false;
    static public $searchConditions = false;
    public static $browseCalcFoundRows = true;
    
    static public $calledClass = __CLASS__;
    static public $responseMode = 'html';
    public static $userResponseModes = array(
        'application/json' => 'json'
        ,'text/csv' => 'csv'
    );
	
	static public function handleRequest()
	{
		// save static class
		static::$calledClass = get_called_class();
	
		switch(static::peekPath())
		{
			case 'csv':
			case 'json':
            case 'pdf':
				static::$responseMode = static::shiftPath();
				break;
		}
		
		return static::handleRecordsRequest();
	}


	static public function handleRecordsRequest($action = false)
	{
		switch($action ? $action : $action = static::shiftPath())
		{
			case 'save':
			{
				return static::handleMultiSaveRequest();
			}
			
			case 'destroy':
			{
				return static::handleMultiDestroyRequest();
			}
			
			case 'create':
			{
				return static::handleCreateRequest();
			}
            
            case '*fields':
            {
                return static::handleFieldsRequest();
            }
			
			case '':
			case false:
			{
                if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    			    return static::handleCreateRequest();
                } else {
				    return static::handleBrowseRequest();
                }
			}

			default:
			{
				if($Record = static::getRecordByHandle(urldecode($action)))
				{
					if(!static::checkReadAccess($Record))
					{
						return static::throwUnauthorizedError();
					}

					return static::handleRecordRequest($Record);
				}
				else
				{
					return static::throwRecordNotFoundError($action);
				}
			}
		}
	}
	
	static public function getRecordByHandle($handle)
	{
		$className = static::$recordClass;
		
        if (ctype_digit($handle) || is_int($handle)) {
            return $className::getByID($handle);
        } elseif (method_exists($className, 'getByHandle')) {
			return $className::getByHandle($handle);
		} else {
			return null;
		}
	}
	
	static public function handleQueryRequest($query, $conditions = array(), $options = array(), $responseID = null, $responseData = array(), $mode = 'AND')
	{
		$className = static::$recordClass;
		$tableAlias = $className::getTableAlias();
		$terms = preg_split('/\s+/', $query);
		
		$options = array_merge(array(
			'limit' =>  !empty($_REQUEST['limit']) && is_numeric($_REQUEST['limit']) ? $_REQUEST['limit'] : static::$browseLimitDefault
			,'offset' => !empty($_REQUEST['offset']) && is_numeric($_REQUEST['offset']) ? $_REQUEST['offset'] : false
		), $options);

		$select = array($tableAlias.'.*');
		$joins = array();
		$having = array();
		$matchers = array();

		foreach($terms AS $term)
		{
			$n = 0;
			$qualifier = 'any';
			$split = explode(':', $term, 2);
			
			if(empty($term))
			{
				continue;
			}
			
			if(count($split) == 2)
			{
				$qualifier = strtolower($split[0]);
				$term = $split[1];
			}
            
            if($qualifier == 'mode' && $term=='or')
            {
                $mode = 'OR';
                continue;
            }
			
			
			$sqlSearchConditions = $className::getSqlSearchConditions($qualifier, $term);

			if(count($sqlSearchConditions['conditions']) == 0 && !$sqlSearchConditions['qualifierFound'])
			{
                return static::throwError('Unknown search qualifier: '.$qualifier);
			}

			$matchers = array_merge($matchers, $sqlSearchConditions['conditions']);
			
			if($sqlSearchConditions['joins'])
			{
				$joins = array_merge($joins, $sqlSearchConditions['joins']);
			}
		}
        
        if(empty($matchers))
        {
            return static::throwError('Query was empty');
        }
		
        if($mode == 'OR') // OR mode, object can match any term and results are sorted by score
        {
    		$select[] = join('+', array_map(function($c) {
    			return sprintf('IF(%s, %u, 0)', $c['condition'], $c['points']);
    		}, $matchers)) . ' AS searchScore';
    		
    		$having[] = 'searchScore > 1';
            
            if(empty($options['order']))
            {
                $options['order'] = array('searchScore DESC');
            }
        }
        else // AND mode, all terms must match 
        {
            // group by qualifier
            $qualifierConditions = array();
            foreach($matchers AS $matcher)
            {
                $qualifierConditions[$matcher['qualifier']][] = $matcher['condition'];
                //$conditions[] = $matcher['condition'];
            }
            
            // compile conditions
            foreach($qualifierConditions AS $newConditions)
            {
                $conditions[] = '( (' . join(') OR (', $newConditions) . ') )';
            }
            
            if(static::$browseOrder)
                $options['order'] = $className::mapFieldOrder(static::$browseOrder);
        }

		return static::respond(
			isset($responseID) ? $responseID : static::getTemplateName($className::$pluralNoun)
			,array_merge($responseData, array(
				'success' => true
				,'data' => $className::getAllByQuery(
					'SELECT DISTINCT %s %s FROM `%s` %s %s WHERE (%s) %s %s %s'
					,array(
                        static::$browseCalcFoundRows ? 'SQL_CALC_FOUND_ROWS' : ''
						,join(',',$select)
						,$className::$tableName
						,$tableAlias
						,!empty($joins) ? implode(' ', $joins) : ''
						,$conditions ? join(') AND (',$className::mapConditions($conditions)) : '1'
						,count($having) ? 'HAVING ('.join(') AND (', $having).')' : ''
						,count($options['order']) ? 'ORDER BY '.join(',', $options['order']) : ''
						,$options['limit'] ? sprintf('LIMIT %u,%u',$options['offset'],$options['limit']) : ''
					)
				)
				,'query' => $query
				,'conditions' => $conditions
			    ,'total' => DB::foundRows()
			    ,'limit' => $options['limit']
			    ,'offset' => $options['offset']
			))
		);
	}


	static public function handleBrowseRequest($options = array(), $conditions = array(), $responseID = null, $responseData = array())
	{
		$className = static::$recordClass;
		
		if(!static::checkBrowseAccess(func_get_args()))
		{
			return static::throwUnauthorizedError();
		}

		if(static::$browseConditions)
		{
			if(!is_array(static::$browseConditions))
				static::$browseConditions = array(static::$browseConditions);
			$conditions = array_merge(static::$browseConditions, $conditions);
		}
		
		$limit = isset($_REQUEST['limit']) && ctype_digit($_REQUEST['limit']) ? (integer)$_REQUEST['limit'] : static::$browseLimitDefault;
		$offset = isset($_REQUEST['offset']) && ctype_digit($_REQUEST['offset']) ? (integer)$_REQUEST['offset'] : false;
		
		if(!empty($_REQUEST['sort'])) {
			$dir = (empty($_REQUEST['dir']) || $_REQUEST['dir'] == 'ASC') ? 'ASC' : 'DESC';
			
			if($className::sorterExists($_REQUEST['sort'])) {
				$order = call_user_func($className::getSorter($_REQUEST['sort']), $dir, $_REQUEST['sort']);
			}
			elseif($className::fieldExists($_REQUEST['sort'])) {
				$order = array(
					$_REQUEST['sort'] => $dir
				);
			}
			else {
				return static::throwError('Invalid sort field');
			}
		}
		else {
			$order = static::$browseOrder;
		}
		
		$options = array_merge(array(
			'limit' =>  $limit
			,'offset' => $offset
			,'order' => $order
            ,'calcFoundRows' => static::$browseCalcFoundRows
		), $options);
		
		// handle query search
		if(!empty($_REQUEST['q']) && $className::$searchConditions)
		{
			return static::handleQueryRequest($_REQUEST['q'], $conditions, array('limit' => $limit, 'offset' => $offset), $responseID, $responseData);
		}


        // get results
        $results = $className::getAllByWhere($conditions, $options);
        $resultsTotal = DB::foundRows();


        // embed tables
        if (!empty($_GET['relatedTable'])) {
            $relatedTables = is_array($_GET['relatedTable']) ? $_GET['relatedTable'] : explode(',', $_GET['relatedTable']);
            
            $related = array();
            foreach ($results AS $result) {
                foreach ($relatedTables AS $relName) {
                    if (!$result::relationshipExists($relName)) {
                        continue;
                    }
                    
                    $relConfig = $result::getStackedConfig('relationships', $relName);
                    if (!$relConfig || $relConfig['type'] != 'one-one') {
                        continue;
                    }
                    
                    $relatedInstance = $result->$relName;
                    if (!$relatedInstance) {
                        continue;
                    }
                    
                    if (empty($related[$relName]) || !in_array($relatedInstance, $related[$relName])) {
                        $related[$relName][] = $relatedInstance;
                    }
                }
            }
            
            $responseData['related'] = $related;
        }
        

        // generate response
		return static::respond(
			isset($responseID) ? $responseID : static::getTemplateName($className::$pluralNoun)
			,array_merge($responseData, array(
				'success' => true
				,'data' => $results
				,'conditions' => $conditions
			    ,'total' => $resultsTotal
			    ,'limit' => $options['limit']
			    ,'offset' => $options['offset']
			))
		);
	}


	static public function handleRecordRequest(ActiveRecord $Record, $action = false)
	{
	
		switch($action ? $action : $action = static::shiftPath())
		{
			case '':
			case false:
			{
				$className = static::$recordClass;
				
				return static::respond(static::getTemplateName($className::$singularNoun), array(
					'success' => true
					,'data' => $Record
				));
			}
			
			case 'comment':
			{
				return static::handleCommentRequest($Record);
			}
			
			case 'edit':
			{
				return static::handleEditRequest($Record);
			}
			
			case 'delete':
			{
				return static::handleDeleteRequest($Record);
			}
		
			default:
			{
				return static::onRecordRequestNotHandled($Record, $action);
			}
		}
	}
	
	static protected function onRecordRequestNotHandled(ActiveRecord $Record, $action)
	{
		return static::throwNotFoundError();
	} 



	static public function handleMultiSaveRequest()
	{
		if($_SERVER['CONTENT_TYPE'] == 'application/json')
		{
			$_REQUEST = JSON::getRequestData();
		}
				
		if(empty($_REQUEST['data']) || !is_array($_REQUEST['data']))
		{
			return static::throwInvalidRequestError('Save expects "data" field as array of record deltas');
		}
		
		$className = static::$recordClass;
		$results = array();
		$failed = array();
        $message = null;

		foreach($_REQUEST['data'] AS $datum)
		{
			// get record
			if(empty($datum['ID']) || !is_numeric($datum['ID']) || $datum['ID'] <= 0)
			{
				$subClasses = $className::getStaticSubClasses();
				
				if (!empty($datum['Class']) && in_array($datum['Class'], $subClasses)) {
					$defaultClass = $datum['Class'];
				} else {
					$defaultClass = $className::getStaticDefaultClass();
				}
				
				$Record = new $defaultClass();
				static::onRecordCreated($Record, $datum);
			}
			else
			{
				if(!$Record = $className::getByID($datum['ID']))
				{
					return static::throwRecordNotFoundError($datum['ID']);
				}
			}
			
			// check write access
			if(!static::checkWriteAccess($Record))
			{
				$failed[] = array(
					'record' => $datum
					,'errors' => 'Write access denied'
				);
				continue;
			}
 			
			// apply delta
			static::applyRecordDelta($Record, $datum);

			// call template function
			static::onBeforeRecordValidated($Record, $datum);

			// try to save record
			try
			{
				// call template function
				static::onBeforeRecordSaved($Record, $datum);

				$Record->save();
				$results[] = (!$Record::fieldExists('Class') || get_class($Record) == $Record->Class) ? $Record : $Record->changeClass();
				
				// call template function
				static::onRecordSaved($Record, $datum);
			}
			catch(RecordValidationException $e)
			{
				$failed[] = array(
					'record' => $Record->getData()
					,'validationErrors' => $e->validationErrors
				);
                
                if (!$message) {
                    $message = reset($e->validationErrors); // store the first validation error in message
                }
			}
		}
		
		return static::respond(static::getTemplateName($className::$pluralNoun).'Saved', array(
			'success' => count($results) || !count($failed)
			,'data' => $results
			,'failed' => $failed
            ,'message' => $message
		));
	}
	
	
	static public function handleMultiDestroyRequest()
	{
		if($_SERVER['CONTENT_TYPE'] == 'application/json')
		{
			$_REQUEST = JSON::getRequestData();
		}
				
		if(empty($_REQUEST['data']) || !is_array($_REQUEST['data']))
		{
			return static::throwInvalidRequestError('Handler expects "data" field as array');
		}
		
		$className = static::$recordClass;
		$results = array();
		$failed = array();
		
		foreach($_REQUEST['data'] AS $datum)
		{
			// get record
			if(is_numeric($datum))
			{
				$recordID = $datum;
			}
			elseif(!empty($datum['ID']) && is_numeric($datum['ID']))
			{
				$recordID = $datum['ID'];
			}
			else
			{
				$failed[] = array(
					'record' => $datum
					,'errors' => 'ID missing'
				);
				continue;
			}

			if(!$Record = $className::getByID($recordID))
			{
				$failed[] = array(
					'record' => $datum
					,'errors' => 'ID not found'
				);
				continue;
			}
			
			// check write access
			if(!static::checkWriteAccess($Record))
			{
				$failed[] = array(
					'record' => $datum
					,'errors' => 'Write access denied'
				);
				continue;
			}
		
			// destroy record
			if($Record->destroy())
			{
				$results[] = $Record;
			}
		}
		
		return static::respond(static::getTemplateName($className::$pluralNoun).'Destroyed', array(
			'success' => count($results) || !count($failed)
			,'data' => $results
			,'failed' => $failed
		));
	}


	static public function handleCreateRequest(ActiveRecord $Record = null)
	{
		// save static class
		static::$calledClass = get_called_class();
		$className = static::$recordClass;

		if (!$Record) {
			$subClasses = $className::getStaticSubClasses();
			
			if (!empty($_REQUEST['Class']) && in_array($_REQUEST['Class'], $subClasses)) {
				$defaultClass = $_REQUEST['Class'];
			} else {
				$defaultClass = $className::getStaticDefaultClass();
			}
			
			$Record = new $defaultClass();
		}
		
		// call template function
		static::onRecordCreated($Record, $_REQUEST);

		return static::handleEditRequest($Record);
	}

	static public function handleEditRequest(ActiveRecord $Record)
	{
		$className = static::$recordClass;

		if(!static::checkWriteAccess($Record))
		{
			return static::throwUnauthorizedError();
		}

		if($_SERVER['REQUEST_METHOD'] == 'POST')
		{
			// apply delta
			static::applyRecordDelta($Record, $_REQUEST);
			
			// call template function
			static::onBeforeRecordValidated($Record, $_REQUEST);

			// validate
			if($Record->validate())
			{
				// call template function
				static::onBeforeRecordSaved($Record, $_REQUEST);
				
				// save session
				$Record->save();
				
				// call template function
				static::onRecordSaved($Record, $_REQUEST);
				
				// fire created response
				$responseID = static::getTemplateName($className::$singularNoun).'Saved';
				$responseData = static::getEditResponse($responseID, array(
					'success' => true
					,'data' => $Record
				));
				return static::respond($responseID, $responseData);
			}
			
			// fall through back to form if validation failed
		}
	
		$responseID = static::getTemplateName($className::$singularNoun).'Edit';
		$responseData = static::getEditResponse($responseID, array(
			'success' => false
			,'data' => $Record
		));
	
		return static::respond($responseID, $responseData);
	}


	static public function handleDeleteRequest(ActiveRecord $Record)
	{
		$className = static::$recordClass;

		if(!static::checkWriteAccess($Record))
		{
			return static::throwUnauthorizedError();
		}
	
		if($_SERVER['REQUEST_METHOD'] == 'POST')
		{
			$Record->destroy();

			// fire created response
			return static::respond(static::getTemplateName($className::$singularNoun).'Deleted', array(
				'success' => true
				,'data' => $Record
			));
		}
	
		return static::respond('confirm', array(
			'question' => 'Are you sure you want to delete this '.$className::$singularNoun.'?'
			,'data' => $Record
		));
	}
	

	static public function handleCommentRequest(ActiveRecord $Record)
	{
		if (!static::checkCommentAccess($Record)) {
			return static::throwUnauthorizedError();
		}

		if ($_SERVER['REQUEST_METHOD'] == 'POST') {
			$Comment = Emergence\Comments\Comment::create(array(
				'Context' => $Record
				,'Message' => $_POST['Message']
			), true);

            return static::respond('commentSaved', array(
                'success' => true
                ,'data' => $Comment
            ));
		} else {
			return static::throwInvalidRequestError();
		}
	}

    public static function handleFieldsRequest()
    {
    	$className = static::$recordClass;

        return static::respond('fields', array(
            'fields' => $className::aggregateStackedConfig('fields'),
            'dynamicFields' => $className::aggregateStackedConfig('dynamicFields')
        ));
    }

	static protected function getTemplateName($noun)
	{
		return preg_replace_callback('/\s+([a-zA-Z])/', function($matches) { return strtoupper($matches[1]); }, $noun);
	}
    
	static public function respondJson($responseID, $responseData = array())
    {
		if (!static::checkAPIAccess($responseID, $responseData, 'json')) {
			return static::throwAPIUnauthorizedError();
		}

        return parent::respondJson($responseID, $responseData);
    }
    
    static public function respondCsv($responseID, $responseData = array())
    {
		if (!static::checkAPIAccess($responseID, $responseData, 'csv')) {
			return static::throwAPIUnauthorizedError();
		}

        return parent::respondCsv($responseID, $responseData);
    }
    
    static public function respondXml($responseID, $responseData = array())
    {
		if (!static::checkAPIAccess($responseID, $responseData, 'xml')) {
			return static::throwAPIUnauthorizedError();
		}

        return parent::respondXml($responseID, $responseData);
    }
	
	static protected function applyRecordDelta(ActiveRecord $Record, $data)
	{
		if(static::$editableFields)
		{
			$Record->setFields(array_intersect_key($data, array_flip(static::$editableFields)));
		}
		else
		{
			return $Record->setFields($data);
		}
	}
	
	// event template functions
	static protected function onRecordCreated(ActiveRecord $Record, $data)
	{
	}
	static protected function onBeforeRecordValidated(ActiveRecord $Record, $data)
	{
	}
	static protected function onBeforeRecordSaved(ActiveRecord $Record, $data)
	{
	}
	static protected function onRecordSaved(ActiveRecord $Record, $data)
	{
	}
	
	static protected function getEditResponse($responseID, $responseData)
	{
		return $responseData;
	}
	
	// access control template functions
	static public function checkBrowseAccess($arguments)
	{
		if(static::$accountLevelBrowse)
		{
			$GLOBALS['Session']->requireAuthentication();
			return $GLOBALS['Session']->hasAccountLevel(static::$accountLevelBrowse);
		}
		
		return true;
	}

	static public function checkReadAccess(ActiveRecord $Record, $suppressLogin=false)
	{
		if(static::$accountLevelRead)
		{
			if(!$suppressLogin)
			{
				$GLOBALS['Session']->requireAuthentication();
			}
			
			return $GLOBALS['Session']->hasAccountLevel(static::$accountLevelRead);
		}
		
		return true;
	}
	
	static public function checkWriteAccess(ActiveRecord $Record, $suppressLogin=false)
	{
		if(static::$accountLevelWrite)
		{
			if(!$suppressLogin)
			{
				$GLOBALS['Session']->requireAuthentication();
			}
			
			return $GLOBALS['Session']->hasAccountLevel(static::$accountLevelWrite);
		}
		
		return true;
	}
	
	static public function checkCommentAccess(ActiveRecord $Record)
	{
		if(static::$accountLevelComment)
		{
			return $GLOBALS['Session']->hasAccountLevel(static::$accountLevelComment);
		}
		
		return true;
	}
	
	static public function checkAPIAccess($responseID, $responseData, $responseMode)
	{
		if(static::$accountLevelAPI)
		{
			$GLOBALS['Session']->requireAuthentication();
			return $GLOBALS['Session']->hasAccountLevel(static::$accountLevelAPI);
		}
		
		return true;
	}
	
	
	static protected function throwRecordNotFoundError($handle, $message = 'Record not found')
	{
		return static::throwNotFoundError($message);
	}
}