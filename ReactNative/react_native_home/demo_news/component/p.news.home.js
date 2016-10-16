/**
 * Created by xudosom on 2016/10/15.
 */

import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    View,
    Text,
    Image,
    ListView,
    AlertIOS,
    TouchableOpacity,
    AsyncStorage,
} from 'react-native';

var LocalData = require('../resource/p.news.localData.json');
var PNewsHomeCell = require('./p.news.home.cell');
var pNewsDetail = require('./p.news.home.newsDetail');

var PNewsHome = React.createClass({
    getDefaultProps: function () {
        return {
            url_api: 'http://api.dagoogle.cn/news/get-news?tableNum=1&page=2&pagesize=20',
            key_word: 'data',
        };
    },

    getInitialState: function () {
        var dataSource = new ListView.DataSource({rowHasChanged: (r1, r2)=>r1 != r2});
        return {
            dataSource: dataSource.cloneWithRows(LocalData[this.props.key_word]),
        }
    },

    //复杂的操作：数据请求  或者  异步操作(定时器)
    componentDidMount: function () {
        fetch(this.props.url_api)
            .then((response)=>response.json())
            .then((responseData)=> {
                console.log(responseData);
                var jsonData = responseData[this.props.key_word];
                this.setState({
                    dataSource: this.state.dataSource.cloneWithRows(jsonData),
                });
            })
            .catch((error)=> {
                if (error) {
                    AlertIOS.alert('提示', "网络请求异常，请稍后重试！");
                }
            })
    },

    render: function () {
        return (
            <ListView
                style={{flex: 1}}
                dataSource={this.state.dataSource}
                renderRow={this.renderRow}
                renderHeader={this.renderHeader}
                enableEmptySections={true}
            />
        );
    },

    renderHeader: function () {
        return (
            <View>
                <Text>这是表头</Text>
            </View>
        );
    },

    renderRow: function (rowData, sectionID, rowID, highlightRow) {
        console.log(rowData);
        var view =
            <TouchableOpacity onPress={()=>this.pushToDetail(rowData)}>

                <PNewsHomeCell newsData={rowData}/>

            </TouchableOpacity>
        return view;
    },

    pushToDetail: function (rowData) {
        let jsonStringfy = JSON.stringify(rowData);
        AsyncStorage.setItem('key', jsonStringfy, function(errs){
            //TODO:错误处理
            if (errs) {
                console.log('存储错误');
            }
            if (!errs) {
                console.log('存储无误');
            }
        });

        this.props.navigator.push({
           component:pNewsDetail,
            title:rowData.title,
            passProps:{rowData},
        });
    },
});

const styles = StyleSheet.create({
    container: {
        backgroundColor: '#F5F5F5',
        justifyContent: 'center',
        alignItems: 'center',
    },

});

module.exports = PNewsHome;