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
                    titleView={()=>this.titleView()}
                />

                <Text>商家</Text>
            </View>
        );
    };

    //TODO:导航栏标题
    titleView() {
        return (
            <Text style={{color: 'white', fontSize: 17}}>商家</Text>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: 'white',
    },
});