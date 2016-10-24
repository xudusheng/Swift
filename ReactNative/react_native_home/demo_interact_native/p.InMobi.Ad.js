/**
 * Created by xudosom on 2016/10/24.
 */

import React, {
    Component,
} from 'react';

import {
    requireNativeComponent
} from 'react-native';

var InMobiAdView = requireNativeComponent('XDSInMobiAdView', null);

import Dimensions from 'Dimensions';
let {width, height} = Dimensions.get('window');

export default class InMobiView extends Component {
    render() {
        return (
            <InMobiAdView style={{width: width, height: 50, backgroundColor: 'red'}}></InMobiAdView>
        );
    }


}