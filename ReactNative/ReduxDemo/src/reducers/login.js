/**
 * Created by xudosom on 2016/10/17.
 */

import * as types from '../const/types';

const initialState = {
    'isLoginedIn': false,
    'user': {},
    'status': null,//登陆操作状态 ‘done’:已登陆,'doing':正在登陆，null：没有登陆
};

export default function user(state = initialState, action = {}) {
    switch (action.type) {
        case types.LOGIN: {
            return {
                ...state,
                isLoginedIn: true,
                user: action.user,
                status: 'done',
            };
        }
        case types.LOGIN_ING: {
            return {
                ...state,
                isLoginedIn: false,
                status: 'doing',
            };
        }
        case types.LOGIN_OUT: {
            return {
                ...state,
                isLoginedIn:false,
                status:null,
            };
        }
        case types.LOGIN_ERROR: {
            return {
                ...state,
                isLoginedIn:false,
                status:null,
            };
        }
        default: {
            return state;
        }

    }

};