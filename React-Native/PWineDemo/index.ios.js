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
    Image,
} from 'react-native';

var WineData = require('./resource/wine/Wine.json');

export default class PWineDemo extends Component {
    render() {
        return (
            <View style={styles.container}>
                {this.renderWine()}
            </View>
        );
    }


    renderWine() {
        var views = [];
        for (var i = 0; i < WineData.length; i++) {
            var wine = WineData[i];
            views.push(
                <View key={i} style={styles.outViewStyle}>
                    <Image source={{uri: wine.image}} style={styles.imageStyle}/>
                    <Text style={styles.textStyle}>{wine.image}</Text>
                </View>
            )
        }
        return views;
    }
}

const styles = StyleSheet.create({
    container: {
        // flex: 1,
        // justifyContent: 'center',
        // alignItems: 'center',
        backgroundColor: '#F5FCFF',
        flexWrap: 'wrap',
        justifyContent:'space-around',
        flexDirection: 'row',
    },
    outViewStyle: {
        alignItems: 'center',
        width: 100,
        height: 100,
        marginTop:20,
    },
    imageStyle: {
        width: 80,
        height: 80,
        backgroundColor: 'yellow',
    },

    textStyle: {
        fontSize: 13,
    }
});

AppRegistry.registerComponent('PWineDemo', () => PWineDemo);
