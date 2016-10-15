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
var PTextInput = require('./demo_UI/p.textInput');
var PTouchable = require('./demo_UI/p.touchable');
var PScrollView = require('./demo_UI/p.scrollView');
var PListView = require('./demo_UI/p.listView');

//综合练习
var PLoginView = require('./demo_loginView/p.loginView');
var PBanner = require('./demo_banner/p.banner');

export default class React_native_home extends Component {
    render() {
        return (
            //React Native UI练习
            // <PTextInput/>
            // <PTouchable/>
            // <PScrollView/>
            <PListView/>

            //综合练习
            //<PLoginView/>
            //<PBanner/>
        )
            ;
    }
}


AppRegistry.registerComponent('react_native_home', () => React_native_home);
