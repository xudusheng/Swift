/**
 * Created by zhengda on 16/10/14.
 */
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
    View,
    Text,
    ScrollView,
} from 'react-native';

export default class PScrollView extends Component {

    render() {
        return (
            <ScrollView
                horizontal={true}
                pagingEnabled={true}
                showsHorizontalScrollIndicator={false}
                bounces={false}
            >
                {this.addChildViews()}

            </ScrollView>
        );
    };

    addChildViews() {
        var childrend = [];
        var colors = ['red', 'green', 'yellow', 'brown'];
        for (var i = 0; i < colors.length; i++) {
            childrend.push(
                <View key={i} style={{width: 375, height: 120, backgroundColor: colors[i]}}>
                </View>
            );
        }
        return childrend;
    }

}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: 'red',
    },

});


module.exports = PScrollView;