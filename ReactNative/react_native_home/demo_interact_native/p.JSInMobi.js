/**
 * Created by xudosom on 2016/10/24.
 */

import React, {
    Component,
    PropTypes,
} from 'react';

import {
    requireNativeComponent,
    View,
    Text,
    TouchableOpacity,
} from 'react-native';

var InMobiAdView = requireNativeComponent('XDSInMobiAdView', null);


import Dimensions from 'Dimensions';
let {width, height} = Dimensions.get('window');

export default class JSInMobAdView extends Component {
    constructor() {
        super();
        this.state = {
            isBannerFinishLoading: false
        };

    }

    render() {
        let isBannerFinishLoading = this.state.isBannerFinishLoading;
        let bannerHeight = isBannerFinishLoading ? 50 : 0;
        let bannerWidth = isBannerFinishLoading ? width : 0;
        console.log('xxxxxxxxxxx = ' + isBannerFinishLoading);
        return (
            <View style={{backgroundColor: 'red'}}>

                <InMobiAdView
                    style={{width: width, height: bannerHeight}}
                    title='我只是一个标题'
                    finishLoadingBlock={alert('广告加载成功')}
                ></InMobiAdView>

                <Text> 点击=>>广告加载完成 </ Text >

                <Text> 点击=>>广告加载完成 </ Text >
                <Text> 点击=>>广告加载完成 </ Text >
                <Text> 点击=>>广告加载完成 </ Text >
                <Text> 点击=>>广告加载完成 </ Text >
                <Text> 点击=>>广告加载完成 </ Text >
                <Text> 点击=>>广告加载完成 </ Text >

                <TouchableOpacity onPress={()=> {
                    this.setState({
                        isBannerFinishLoading: true
                    });
                }}>
                    <Text style={{color: 'white'}}> 点我，点我，点我才可以刷新 </ Text >
                </TouchableOpacity>
            </View>
        );
    }

    updateView() {
        console.log('收到一条广告更新')
        this.setState({
            isBannerFinishLoading: true
        })
    }

}