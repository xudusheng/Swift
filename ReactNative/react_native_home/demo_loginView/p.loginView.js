/**
 * Created by zhengda on 16/10/13.
 */
/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    Image,
    TextInput,
} from 'react-native';

var Dimensions = require('Dimensions');
var ScreenWidth = Dimensions.get('window').width;

export default class LoginView extends Component {
    render() {
        return (
            <View style={styles.container}>
                {/*//头像*/}
                <Image source={require('./img/icon.png')} style={styles.icomImageStyle}/>

                {/*//用户名*/}
                <TextInput placeholder={'请输入用户名'} style={styles.textInputStyle}/>

                {/*//密码*/}
                <TextInput placeholder={'请输入密码'} password={true} style={styles.textInputStyle}/>

                {/*//登录*/}
                <View style={styles.loginButtonStyle}>
                    <Text style={{color: 'white'}}>登录</Text>
                </View>

                {/*//无法登陆、新用户*/}
                <View style={styles.settingStyle}>
                    <Text>无法登录</Text>
                    <Text>新用户</Text>
                </View>

                {/*//其他方式登陆*/}
                <View style={styles.otherLoginStyle}>
                    <Text>其他方式登陆:</Text>
                    <Image source={require('./img/icon3.png')} style={styles.otherLoginImageStyle}/>
                    <Image source={require('./img/icon7.png')} style={styles.otherLoginImageStyle}/>
                    <Image source={require('./img/icon8.png')} style={styles.otherLoginImageStyle}/>
                </View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#dddddd',
        alignItems: 'center',
    },

    icomImageStyle: {
        marginTop: 80,
        marginBottom: 30,
        width: 80,
        height: 80,
        borderWidth: 2,
        borderColor: 'white',
        borderRadius: 40,
    },

    textInputStyle: {
        marginBottom: 1,
        height: 40,
        backgroundColor: 'white',
        textAlign: 'center',
    },

    loginButtonStyle: {
        marginTop: 20,
        marginBottom: 20,

        width: ScreenWidth-40,
        height: 35,
        backgroundColor: 'blue',

        justifyContent: 'center',
        alignItems: 'center',

        borderRadius: 5,
    },

    settingStyle: {
        flexDirection: 'row',
        width: ScreenWidth-40,
        justifyContent: 'space-between'
    },
    otherLoginStyle: {
        flexDirection: 'row',
        alignItems: 'center',
        //绝对定位
        position:'absolute',
        bottom:10,
        left:20,
    },
    otherLoginImageStyle:{
      width:40,
        height:40,
        borderRadius:20,
        marginLeft:8,
    },
});


module.exports = LoginView;