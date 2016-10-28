/**
 * Created by zhengda on 16/10/28.
 */
import React, {Component, PropTypes} from 'react';

import {
    StyleSheet,
    View,
    Image,
    Text,
    TouchableOpacity,
} from 'react-native';

export default class QMovieSumaryView extends Component {
    static defaultProps = {
        title: '',
        sumary: '',
    };
    static propTypes = {
        title: PropTypes.string.isRequired,
        sumary: PropTypes.string.isRequired,
    };

    render() {
        return (
            <View>
                <Text style={sumaryStyles.titleStyle}>
                    {'《' + this.props.title + '》的简介'}</Text>

                <Text style={sumaryStyles.sumaryStyle}>
                    {this.props.sumary}</Text>
            </View>
        );
    }

}

const sumaryStyles = StyleSheet.create({

    titleStyle: {
        fontSize: 13,
        fontWeight:'100',
        margin: 10,
        color: '#5cb85c',
    },

    sumaryStyle: {
        fontSize: 11,
        fontWeight:'100',
        marginLeft: 10,
        marginRight: 10,
        color: '#999999',
        lineHeight: 20,
    },

});
