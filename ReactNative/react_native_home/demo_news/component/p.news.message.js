/**
 * Created by xudosom on 2016/10/15.
 */

import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    View,
    Text,
} from 'react-native';


var PNewsMessage = React.createClass({
    render(){
        return (
            <View style={styles.container}>
                <Text>消息</Text>
            </View>
        );
    },

});

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#F5F5F5',
        justifyContent:'center',
        alignItems:'center',
    },

});

module.exports = PNewsMessage;