/**
 * Created by xudosom on 2016/10/16.
 */
import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    View,
    Text,
    Image,
} from 'react-native';

var PHomeCell = React.createClass({

    getDefaultProps(){
      return {
          newsData:{},
      }
    },

    render(){
        return(
            <View style={styles.cellContentViewStyle}>
                <Image source={{uri: this.props.newsData.top_image}} style={styles.imageStyle}/>
                <View style={styles.textViewStyle}>
                    <Text style={styles.titleStyle}>{this.props.newsData.title}</Text>
                    <Text style={styles.moneyStyle}>{this.props.newsData.digest}</Text>
                </View>
            </View>
        );
    }
});


const styles = StyleSheet.create({
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
        fontSize: 15,
        marginBottom: 5,
        marginTop: 10,
    },

    moneyStyle: {
        fontSize: 13,
        marginBottom: 10,
        color: '#666666',
    }
});

module.exports = PHomeCell;