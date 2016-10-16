/**
 * Created by xudosom on 2016/10/16.
 */
import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    View,
    Text,
    Image,
    AsyncStorage,
} from 'react-native';

var PNewsDetail = React.createClass({
    getInitialState(){
      return{
       jsonString:'',
      };
    },

    componentDidMount:function () {
        AsyncStorage.getItem('key', function (error, result) {
            if (result) {

                console.log(result);
                this.setState({
                    jsonString:result
                })
            }
        }.bind(this));
    },

    render: function () {
        // console.log(this.state.jsonString);
        return (
            <View style={{flex:1, justifyContent:'center', alignItems:'center'}}>
                <Text>{this.state.jsonString}</Text>
            </View>
        );
    },
});

module.exports = PNewsDetail;