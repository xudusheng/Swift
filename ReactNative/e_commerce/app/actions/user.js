/**
 * Created by zhengda on 16/10/18.
 */
import {AlertIOS} from 'react-native';
import * as TYPES from './types';

let testUser = {
    'name': 'juju',
    'age': 20,
    'avatar': 'https://www.baidu.com'
};

let skipUser = {
    'name': 'guest',
    'age': 20,
    'avatar': 'https://www.baidu.com'
};


//login
export function login() {
    return ((dispatch)=> {
        dispatch({'type': TYPES.LOGGED_DOING});
        let inner_get = fetch('https://www.baidu.com')
            .then((resp)=> {
                //登陆成功
                dispatch({'type': TYPES.LOGGED_IN, user: testUser});
            })
            .catch((e)=> {
                //登陆失败
                AlertIOS.alert(e.message);
                dispatch({'type': TYPES.LOGGED_ERROR, error: e});
            });
    });
};


//skip login
export function skipLogin() {
    return {
        'type': TYPES.LOGGED_IN,
        user: skipUser,
    }
};


//logout
export function logout() {
    return {
        'type': TYPES.LOGGED_OUT,
    }
};