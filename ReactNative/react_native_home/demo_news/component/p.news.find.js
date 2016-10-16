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


var PNewsFind = React.createClass({
    render(){
        return (
            <View style={styles.container}>
                <Text>发现</Text>
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

module.exports = PNewsFind;