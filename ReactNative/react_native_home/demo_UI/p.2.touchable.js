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
    TouchableOpacity,
} from 'react-native';

export default class PTouchable extends Component {
    render() {
        return (
            <View style={styles.container}>
                {this.renderTouchable()}
            </View>
        );
    }

    renderTouchable() {
        var view = <View>
            <TouchableOpacity activeOpacity={0.5}
                              onPress={()=>this.renderOnPress()}
                              onLongPress={()=>this.renderOnLongPress()}

            >
                <Text>我是文本，但可以点击。</Text>
            </TouchableOpacity>
        </View>
        return view;
    }

    //onPress
    renderOnPress() {
        console.log('renderOnPress');
    }

    renderOnLongPress() {
        console.log('renderOnLongPress');
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: '#F5FCFF',
    },

});


module.exports = PTouchable;