/**
 * Created by zhengda on 16/10/26.
 */


import React, {Component} from 'react';
import {
    StyleSheet,
    Navigator
} from 'react-native';

import QHome from './pages/p.home';

var DomParser = require('react-native-html-parser').DOMParser;

export default class QRoot extends Component {
    render() {
        return (
            <Navigator
                initialRoute={{name: '首页', component: QHome}}
                configureScene={()=>Navigator.SceneConfigs.PushFromRight}
                renderScene={(route, navigator)=> {
                    let Component = route.component;
                    return <Component {...route.passProps} navigator={navigator}/>;
                }}
            />
        );
    }
}
