/**
 * Created by xudosom on 2016/10/20.
 */
import React, {Component} from 'react';

import {
    StyleSheet,
    View,
    Image,
    Text,
    Switch,
    TouchableOpacity,
} from 'react-native';


export default class MineCell extends Component {

    static defaultProps = {
        icon: '',
        title: '',
        subTitle: '',
        height: 44,
        onClick: (index)=> {
        },
    };

    static propTypes = {
        icon: React.PropTypes.string.isRequired,
        title: React.PropTypes.string.isRequired,
        subTitle: React.PropTypes.string,
        height: React.PropTypes.number,
        onClick: React.PropTypes.func,
    };

    constructor(props) {
        super(props);
    }

    render() {
        return (
            <TouchableOpacity onPress={()=>{this.props.onClick(index=0)}}>
                <View style={[styles.container, {height: this.props.height}]}>
                    {this.renderIconAndTitleView()}
                    {this.renderCellView()}
                </View>
            </TouchableOpacity>
        );
    }

    //TODO:左右部分UI
    renderIconAndTitleView() {
        return (
            <View style={styles.iconAndTitleStyle}>
                {this.renderIconView()}
                <Text style={styles.titleStyle}>{this.props.title}</Text>
            </View>
        );
    }

    renderIconView() {
        if (this.props.icon.length) {
            return (<Image source={{uri: this.props.icon}} style={{width: 24, height: 24}}/>);
        }
    }

    //TODO:右边部分UI
    renderCellView() {
        return (
            <View style={styles.rightViewStyle}>
                <Text style={styles.subTitleStyle}>{this.props.subTitle}</Text>
                <Image source={{uri: 'icon_cell_rightArrow'}} style={styles.rightArrowStyle}/>
            </View>
        );
    }

};

const margin = 15;
const styles = StyleSheet.create({
    container: {
        flexDirection: 'row',
        backgroundColor: 'white',
        alignItems: 'center',
        justifyContent: 'space-between',
        borderBottomColor: '#eeeeee',
        borderBottomWidth: 0.5,
    },

    iconAndTitleStyle: {
        flexDirection: 'row',
        alignItems: 'center',
        marginLeft: margin,
    },
    titleStyle: {
        color: '#222222',
        marginLeft: margin / 2,
    },
    subTitleStyle: {
        fontSize:13,
        color: '#666666',
        fontWeight: '200',
    },
    rightViewStyle: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    switchStyle: {
        marginRight: margin,
    },
    rightArrowStyle: {
        width: 8,
        height: 13,
        marginRight: margin,
        marginLeft: 8,
    },
});