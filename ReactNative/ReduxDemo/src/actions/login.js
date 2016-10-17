/**
 * Created by xudosom on 2016/10/17.
 */

import * as types from '../const/types';
import {AlertIOS} from 'react-native';

export function login(user) {
    return dispatch=>{
      //登录中派遣给LOGIN_ING
        dispatch({type:types.LOGIN_ING});
        let result = fetch('http://www.baidu.com')
            .then((response)=>{
                setTimeout(()=>{
                    if (user.phone == '18321985187' && user.password == '123456'){
                        dispatch({type:types.LOGIN, user:user});
                    }else {
                        AlertIOS.alert("用户名或密码错误");
                        dispatch(loginError());
                    }
                })
            })
            .catch((error)=>{
                alert(error);
                dispatch(loginError());
            })
    };
}

function loginError() {
    return {
        type:types.LOGIN_ERROR,
    };
};

export function logout() {
  return {
    type:types.LOGIN_OUT
  };
};