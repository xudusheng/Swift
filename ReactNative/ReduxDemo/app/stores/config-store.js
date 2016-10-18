/**
 * Created by zhengda on 16/10/18.
 */

import {createStore, applyMiddleware} from 'redux';
import thunk from 'redux-thunk';//引入异步操作
import indexReducer from '../reducers/index';
import reducers from '../reducers';

const logger = store => next => action => {
  if(typeof  action === 'function')
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


export default function configureStore(initialState) {

    const store = creatSoreWithMiddleware(indexReducer, initialState);
    if (module.hot) {
        module.hot.accept(reducers, ()=> {
            store.replace(indexReducer);
        });
    }
    return store;
};

