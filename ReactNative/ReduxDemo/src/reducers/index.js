/**
 * Created by xudosom on 2016/10/17.
 */

import {combineReducers} from 'redux';
import login from './login';

const rootReducer = combineReducers({
   login,
});

export  default rootReducer;