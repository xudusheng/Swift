/**
 * Created by zhengda on 16/10/18.
 */


import  {combineReducers} from 'redux';
import movie from './movie';

export default combineReducers({
   movieReducer:movie,
});