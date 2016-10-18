/**
 * Created by zhengda on 16/10/18.
 */

import React,{Component} from 'react';
import {View} from 'react-native';

export default class Root extends Component {

    componentDidMount() {
        // this.props.state;
        const {login} = this.props.actions;
        login();
    }
    render() {
        return (
            <View style={{flex:1, backgroundColor:'red'}}></View>
        );
    };
};