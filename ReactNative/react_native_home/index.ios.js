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
    NavigatorIOS,
} from 'react-native';

//React Native UI练习
var PTextInput = require('./demo_UI/p.1.textInput.js');
var PTouchable = require('./demo_UI/p.2.touchable.js');
var PScrollView = require('./demo_UI/p.3.scrollView.js');
var PListViewPlain = require('./demo_UI/p.4.listView.singleGroup.js');
var PListViewGroup = require('./demo_UI/p.5.listView.mulGroup.js');
var PTabBar = require('./demo_UI/p.6.tabbar');

//综合练习
var PLoginView = require('./demo_loginView/p.loginView');
var PBanner = require('./demo_banner/p.banner');
var PNewsMain = require('./demo_news/component/p.news.main');

var React_native_home = React.createClass({
    render() {
        return (
            //React Native UI练习
            // <PTextInput/>
            // <PTouchable/>
            // <PScrollView/>
            //<PListViewPlain/>
            //<PListViewGroup/>
            // <PTabBar/>


            //综合练习
            //<PLoginView/>
            //<PBanner/>
            <PNewsMain/>

        );
    }
});



AppRegistry.registerComponent('react_native_home', () => React_native_home);
