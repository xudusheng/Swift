/**
 * Created by zhengda on 16/10/19.
 */

import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    StatusBar,
    Navigator,

} from 'react-native';

import NavigatiowView from '../../component/e.navigationView';

export default class Shop extends Component {

    render() {
        return (
            <View style={styles.container}>

                <NavigatiowView
                    leftView={()=>this.leftView()}
                    titleView={()=>this.leftView()}
                    rightView={()=>this.leftView()}
                />

                <Text>商城路</Text>
            </View>
        );
    };

    leftView() {
        return (
            <View style={{backgroundColor: 'black', width:60, height:30}}></View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: 'white',
    },
});