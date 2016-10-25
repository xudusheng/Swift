/**
 * Created by xudosom on 2016/10/23.
 */
import React, {
    Component,
} from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    TextInput,
    TouchableOpacity,
    NativeModules,
} from 'react-native';

import {
    requireNativeComponent
} from 'react-native';


var SpringBoard = NativeModules.SpringBoard;

import JSInMobAdView from './p.JSInMobi';

export default class PJSView extends Component {
    render() {
        return (
            < View style={styles.container}>
                <TouchableOpacity>
                    <Text> 点击跳转到 =>原生页面 </ Text >
                </TouchableOpacity>

                <JSInMobAdView></JSInMobAdView>

                <Text> 点我，点我，快点我 </ Text >
                <Text> 点我，点我，快点我 </ Text >
                <Text> 点我，点我，快点我 </ Text >
                <Text> 点我，点我，快点我 </ Text >

            </ View >
        );
    }


}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: '#F5FCFF',
    },
    textInputStyle: {
        marginTop: 20,
        // width: 200,
        height: 40,
        borderWidth: 0.5,
        borderColor: '#181818',
    }

});

