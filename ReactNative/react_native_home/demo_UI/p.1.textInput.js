/**
 * Created by zhengda on 16/10/14.
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
    TextInput,
} from 'react-native';

export default class PTextInput extends Component {
    render() {
        return (
            <View style={styles.container}>
                {this.renderTextInput()}
            </View>
        );
    }


    //--------------------------TextInput--------------------------
    renderTextInput() {
        var textInput = <TextInput style={styles.textInputStyle}
            //键盘类型
                                   keyboardType='default'
            //多行显示
                                   multiline={false}
            //密码显示
                                   password={false}
            //空白输入框文本
                                   placeholder={'请输入密码'}
                                   placeholderTextColor={'red'}
            //清除按钮
                                   clearButtonMode={'while-editing'}
        />
        return textInput;
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: '#F5FCFF',
    },
    textInputStyle: {
        marginTop: 20,
        // width: 200,
        height: 40,
        borderWidth: 0.5,
        borderColor: '#181818',
    }

});


module.exports = PTextInput;