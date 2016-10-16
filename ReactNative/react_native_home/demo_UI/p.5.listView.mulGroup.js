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
    TouchableOpacity,
    AlertIOS,
} from 'react-native';

var Car = require('./resource/car.json');

var PListViewGroup = React.createClass({

    //初始化函数
    getInitialState(){
        var getSectionDataSource = (dataBlob, sectionID) => {
            return dataBlob[sectionID];
        };
        var getRowDataSource = (dataBlob, sectionID, rowID) => {
            return dataBlob[sectionID + ':' + rowID];
        };

        return {
            dataSource: new ListView.DataSource({
                getSectionData: getSectionDataSource,//获取组中的数据
                getRowData: getRowDataSource,//获取行中的数据
                rowHasChanged: (r1, r2) => r1 !== r2,
                sectionHeaderHasChanged: (s1, s2) => s1 != s2,
            }),
        }
    },

    //复杂的操作：数据请求  或者  异步操作(定时器)
    componentDidMount(){
        //拿到json数据
        var jsonData = Car.data;

        //定义一下变量
        var dataBlob = {},
            sectionIDs = [],
            rowIDs = [];

        //遍历
        for (var i = 0; i < jsonData.length; i++) {
            //1、把组好放入sectionIDs数组中
            sectionIDs.push(i);

            //2、把组中的内容放入dataBlob
            dataBlob[i] = jsonData[i].title;

            //3、取出改组中所有的车
            var cars = jsonData[i].cars;
            var rowIdsInCurrentSection = [];

            //4、遍历所有的车数组
            for (var j = 0; j < cars.length; j++) {
                //把行号放入rowIdsInCurrentSection
                rowIdsInCurrentSection.push(j);
                dataBlob[i + ':' + j] = cars[j];
            }
            rowIDs.push(rowIdsInCurrentSection);
        }

        //更新状态
        this.setState({
            dataSource: this.state.dataSource.cloneWithRowsAndSections(dataBlob, sectionIDs, rowIDs),
        });
    },

    render(){
        return <ListView
            style={{marginTop:20}}
            dataSource={this.state.dataSource}
            renderRow={this.renderRow}
            renderSectionHeader={this.renderSectionHeader}
        />;
    },

    //每一行的数据
    renderRow(rowData, sectionID, rowID) {
        return <TouchableOpacity>
            <View style={styles.rowContentStyle}>
                <Image source={{uri: rowData.icon}} style={styles.rowImageStyle}/>
                <Text style={{marginLeft:5,}}>{rowData.name}</Text>
            </View>
        </TouchableOpacity>
    },

    //每一组的数据
    renderSectionHeader(sectionData, sectionID){
        return (
            <View style={styles.sectionHeaderViewStyle}>
                <Text style={{marginLeft:10, color:'red'}}>{sectionData}</Text>
            </View>
        );
    },
});


const styles = StyleSheet.create({

    rowContentStyle: {
        flexDirection:'row',
        alignItems:'center',
        padding:10,
        borderBottomWidth:0.5,
        borderBottomColor:'#e8e8e8',
    },

    rowImageStyle: {
        width: 40,
        height: 40,
    },

    sectionHeaderViewStyle: {
        backgroundColor: '#e8e8e8',
        height: 25,
        justifyContent:'center',
    },
});

module.exports = PListViewGroup;