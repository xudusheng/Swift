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

var AdView = requireNativeComponent('XDSAdView', null);
var InMobiAdView = requireNativeComponent('XDSInMobiAdView', null);

var SpringBoard = NativeModules.SpringBoard;

export default class PJSView extends Component {
    render() {
        return (
            < View style={styles.container}>
                <TouchableOpacity
                    onPress={()=>{SpringBoard.addAdView();}
                    }>
                    <Text> 点击跳转到 =>原生页面 </ Text >
                </TouchableOpacity>

                {/*<InMobiAdView style={{width:414, height:55, backgroundColor:'red'}}></InMobiAdView>*/}

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

