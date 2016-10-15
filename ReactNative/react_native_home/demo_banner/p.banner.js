/**
 * Created by zhengda on 16/10/14.
 */

import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    View,
    Text,
    Image,
    ScrollView,
    TouchableOpacity,
} from 'react-native';

var BannerData = require('./resource/ImageData.json').data;
var Dimensions = require('Dimensions');
var ScreenWidth = Dimensions.get('window').width;

var PBanner = React.createClass({
    getInitialState(){
        return ({
            currentPage: 0,
        });
    },
    render(){
        return (
            <View style={styles.container}>
                <ScrollView
                    horizontal={true}
                    pagingEnabled={true}
                    showsHorizontalScrollIndicator={false}
                    style={{marginTop: 20,}}
                    onMomentumScrollEnd={(e)=>this.scrollEnd(e)}
                >
                    {this.addChildViews()}
                </ScrollView>
                <View style={styles.pageViewStyle}>
                    {this.addPageCircles()}
                </View>
            </View>
        );
    },

    //添加scrollView上的图片
    addChildViews(){
        var childrend = [];
        console.log(BannerData.length + '==' + ScreenWidth);
        for (var i = 0; i < BannerData.length; i++) {
            var aBanner = BannerData[i];
            childrend.push(
                <TouchableOpacity key={i}>
                    <Image source={{uri: aBanner.img}}
                           style={{backgroundColor: 'yellow', width: ScreenWidth, height: 120}}/>
                </TouchableOpacity>
            )
        }
        return childrend;
    },

    //添加page小圆点
    addPageCircles(){
        var circles = [];
        for (var i = 0; i < BannerData.length; i++) {
            circles.push(
                <Text key={i}
                      style={{color: (i == this.state.currentPage) ? 'red' : 'white', fontSize: 20,}}>&bull;</Text>
            );
        }
        return circles;
    },

    //
    scrollEnd(e){
        var offsetX = e.nativeEvent.contentOffset.x;
        var page = Math.floor(offsetX / ScreenWidth);
        var aBanner = BannerData[page];
        console.log(page);
        this.setState({
            currentPage:page,
        })
    }
});

const styles = StyleSheet.create({
    container: {},
    pageViewStyle: {
        height: 25,
        width: ScreenWidth,
        backgroundColor: 'rgba(1,1,1,0.2)',
        position: 'absolute',
        bottom: 0,

        flexDirection: 'row',
        alignItems: 'center',

    }
});

module.exports = PBanner;