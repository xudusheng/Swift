/**
 * Created by Hmily on 2016/11/27.
 */
import React, {Component} from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    Navigator,
    TouchableOpacity,
} from 'react-native';


export default class NewsDetailView extends Component {
    render(){
        console.log(this.props.title);
        return (
            <View style={{flex:1, backgroundColor:'white'}}></View>
        );
    }

}