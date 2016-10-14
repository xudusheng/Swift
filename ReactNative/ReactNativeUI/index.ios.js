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
    TextInput,
    Image,
    TouchableOpacity,
} from 'react-native';

//React Native UI练习
var PTextInput = require('./p.textInput');
var PTouchable = require('./p.touchable');
var PScrollView = require('./p.scrollView');


//综合练习
var PLoginView = require('./loginViewDemo/p.loginView');
var PBanner = require('./bannerDemo/p.banner');

export default class ReactNativeUI extends Component {
    render() {
        return (
            //React Native UI练习
            // <PTextInput/>
            // <PTouchable/>
            // <PScrollView/>

            //综合练习
            //<PLoginView/>
            <PBanner/>
        );
    }
}


AppRegistry.registerComponent('ReactNativeUI', () => ReactNativeUI);
