/**
 * Created by zhengda on 16/10/18.
 */

import * as TYPES from '../actions/types';

const initialState = {
    isLogin: false,
    user: {},
    status: null,
};

export default function user(state = initialState, action) {
    switch (action.type) {
        case TYPES.LOGGED_DOING:
            return {
                ...state,
                status: 'doing',
            };

        case TYPES.LOGGED_IN:
            return {
                ...state,
                isLogin: true,
                user: action.user,
            };

        case TYPES.LOGGED_OUT:
            return {
                ...state,
                isLogin: false,
                user: {},
                status: null,
            };

        case TYPES.LOGGED_ERROR:
            return {
                ...state,
                isLogin: false,
                user: {},
                status: null,
            };
        default:
            return state;
    }
};