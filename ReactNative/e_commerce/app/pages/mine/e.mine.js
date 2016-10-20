/**
 * Created by zhengda on 16/10/19.
 */

import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    Image,
    TouchableOpacity,

} from 'react-native';
import NavigatiowView from '../../component/e.navigationView';

export default class Mine extends Component {

    render() {
        return (
            <View style={styles.container}>

                <NavigatiowView
                    titleView={()=>this.titleView()}
                />

                <Text>我的</Text>
            </View>
        );
    };

    //TODO:导航栏标题
    titleView() {
        return (
            <Text style={{color: 'white', fontSize: 17}}>商城</Text>
        );
    }

    rightView() {
        return (
            <View style={{backgroundColor: 'black', width: 60, height: 30}}></View>
        );
    };
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#F5FCFF',
    },
});