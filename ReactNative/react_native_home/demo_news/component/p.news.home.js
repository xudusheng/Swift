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
} from 'react-native';


var PNewsHome = React.createClass({
    getDefaultProps(){
        return {
            url_api: 'http://api.dagoogle.cn/news/get-news?tableNum=1&page=2&pagesize=20',
            key_word: 'data',
        };
    },

    getInitialState(){
        var dataSource = new ListView.DataSource({rowHasChanged: (r1, r2)=>r1 != r2});
        return {
            dataSource: dataSource.cloneWithRows([]),
        }
    },

    //复杂的操作：数据请求  或者  异步操作(定时器)
    componentDidMount(){
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
                    AlertIOS.alert(error);
                }
            })
    },


    render(){
        return (
            <ListView
                style={{flex: 1}}
                dataSource={this.state.dataSource}
                renderRow={this.renderRow}
                //{/*enableEmptySections:{true}*/}
            />
        );
    },

    renderRow(rowData, sectionID, rowID, highlightRow){
        console.log(rowData);
        var view =
            <TouchableOpacity
                onPress={()=>this.pressCell(rowData)}
            >
                <View style={styles.cellContentViewStyle}>
                    <Image source={{uri: rowData.top_image}} style={styles.imageStyle}/>
                    <View style={styles.textViewStyle}>
                        <Text style={styles.titleStyle}>{rowData.title}</Text>
                        <Text style={styles.moneyStyle}>¥{rowData.digest}</Text>
                    </View>
                </View>
            </TouchableOpacity>
        return view;
    },

    pressCell (rowData){
        AlertIOS.alert('提示', rowData.title);
    },
});

const styles = StyleSheet.create({
    container: {
        backgroundColor: '#F5F5F5',
        justifyContent: 'center',
        alignItems: 'center',
    },

    cellContentViewStyle: {
        flexDirection: 'row',
        alignItems: 'center',
        borderBottomWidth: 0.7,
        borderBottomColor: '#e8e8e8',
    },

    imageStyle: {
        width: 60,
        height: 40,
        margin: 10,
    },
    textViewStyle: {
        flex: 1,
    },
    titleStyle: {
        marginBottom: 5,
        marginTop: 10,
        color: '#666666',
    },

    moneyStyle: {
        marginBottom: 10,
        color: '#999999',
    }
});

module.exports = PNewsHome;