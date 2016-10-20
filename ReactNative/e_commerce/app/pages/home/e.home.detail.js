/**
 * Created by zhengda on 16/10/19.
 */
import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
} from 'react-native';

import Detail from './e.home'
export default class Home_Detail extends Component {
    render() {
        return (
            <View style={styles.container}>
                <TouchableOpacity onPress={()=>{this.popToDetail()}}>
                    <Text>详情页</Text>
                </TouchableOpacity>
            </View>
        );
    };

    popToDetail(){
      this.props.navigator.pop();
    };
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: 'red',
    },
});
