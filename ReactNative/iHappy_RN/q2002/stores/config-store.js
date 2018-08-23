/**
 * Created by zhengda on 16/10/31.
 */

import {createStore, applyMiddleware} from 'redux';
import thunk from 'redux-thunk';//引入异步操作

import combineReducers from '../reducers/index';

import * as reducers from '../reducers';

const logger = store => next => action => {
    if (typeof  action === 'function')
        console.log('disPatching a function');
    else
        console.log('dispatching', action);

    let result = next(action);
    console.log('next state', store.getState());
    return result;
};


let middlewares = [
    logger,
    thunk
];


const creatSoreWithMiddleware = applyMiddleware(...middlewares)(createStore);


//配置store信息
export default function configureStore(initialState) {
    console.log('===================')
    console.log(combineReducers);
    const store = creatSoreWithMiddleware(combineReducers, initialState);
    // if (module.hot) {
    //     module.hot.accept(reducers, ()=> {
    //         store.replace(combineReducers);
    //     });
    // }
    return store;
};