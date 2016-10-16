/**
 * Created by xudosom on 2016/10/14.
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

var WineData = require('./resource/wine.json');

var PListView = React.createClass({
    getInitialState(){
        var ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
        return {
            dataSource: ds.cloneWithRows(WineData)
        }
    },

    render(){
        return (
            <ListView
                style={styles.listViewStyle}
                dataSource={this.state.dataSource}
                renderRow={this.renderRow}

            />
        );
    },

    renderRow(rowData, sectionID, rowID, highlightRow){
        var view =
            <TouchableOpacity
                onPress={()=>this.pressCell(rowData)}
            >
                <View style={styles.cellContentViewStyle}>
                    <Image source={{uri: rowData.image}} style={styles.imageStyle}/>
                    <View style={styles.textViewStyle}>
                        <Text style={styles.titleStyle}>{rowData.name}</Text>
                        <Text style={styles.moneyStyle}>¥{rowData.money}</Text>
                    </View>
                </View>
            </TouchableOpacity>
        return view;
    },

    pressCell (rowData){
        console.log(rowData.name);
        AlertIOS.alert('提示', rowData.name);
    }
});

const styles = StyleSheet.create({
    listViewStyle: {
        flex: 1,
        marginTop: 20,
    },
    cellContentViewStyle: {
        flexDirection: 'row',
        // justifyContent:'center',
        borderBottomWidth: 0.5,
        borderBottomColor: 'gray',
        alignItems: 'center',
    },
    imageStyle: {
        width: 60,
        height: 60,
        marginTop: 10,
        marginBottom: 10,
        marginLeft: 15,
        marginRight: 10,
    },
    textViewStyle: {
        flex: 1,
        justifyContent: 'center',
        height: 60,
    },
    titleStyle: {
        marginRight: 10,
        marginBottom: 5,
    },
    moneyStyle: {
        color: 'red',
    },
})

module.exports = PListView;