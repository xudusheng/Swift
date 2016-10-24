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
        onClick: ()=> {
        },
    };

    static propTypes = {
        onClick: React.PropTypes.func,
    };

    constructor(props) {
        super(props);
    }

    render() {
        return (
            <View style={styles.container}>
                {this.nickNameView()}
                {this.itemListView()}
            </View>
        );
    }

    //TODO:头像与昵称
    nickNameView() {
        return (
            <TouchableOpacity onPress={()=> {
                this.props.onClick(index = 0)
            }}>
                <View style={styles.nickNameViewStyle}>
                    <View style={styles.iconAndNickNameViewStyle}>
                        <Image source={{uri: 'xzh'}} style={styles.iconImageStyle}/>
                        <Text style={styles.titleStyle}>小马哥电商</Text>
                        <Image source={{uri: 'avatar_vip'}} style={{width: 20, height: 20}}/>
                    </View>

                    <Image source={{uri: 'icon_cell_rightArrow'}} style={styles.rightArrowStyle}/>
                </View>
            </TouchableOpacity>
        );
    }


    //TODO:评价、收藏
    itemListView() {
        return (
            <View style={styles.itemListViewStyle}>
                {this.createItem('100', '马格权', false)}
                {this.createItem('33', '评价', true)}
                {this.createItem('102', '收藏', false)}
            </View>
        );
    }

    createItem(title, subTitle, showline) {
        if (showline) {
            return (
                <View style={{flexDirection:'row'}}>
                    <View style={{height: 30, width: 0.5, backgroundColor: 'white'}}/>
                    <View style={styles.itemStyle}>
                        <Text style={styles.textStyle}>{title}</Text>
                        <Text style={styles.textStyle}>{subTitle}</Text>
                    </View>
                    <View style={{height: 30, width: 0.5, backgroundColor: 'white'}}/>
                </View>
            );
        } else {
            return (
                <View style={styles.itemStyle}>
                    <Text style={styles.textStyle}>{title}</Text>
                    <Text style={styles.textStyle}>{subTitle}</Text>
                </View>
            );
        }
    }

}
;

const margin = 15;
import Dimensions from 'Dimensions';
let {width, height} = Dimensions.get('window');
const styles = StyleSheet.create({
    container: {
        backgroundColor: 'rgba(255, 96, 0, 1.0)',
        justifyContent: 'space-between',
        borderBottomColor: '#eeeeee',
        borderBottomWidth: 0.5,
    },

    nickNameViewStyle: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        height: 80,
        marginTop: 40,
    },
    iconAndNickNameViewStyle: {
        flexDirection: 'row',
        alignItems: 'center',

    },
    iconImageStyle: {
        marginLeft: 15,
        marginRight: 10,
        width: 60.0,
        height: 60.0,
        borderRadius: 30.0,
        borderColor: 'rgba(25,25,25,0.2)',
        borderWidth: 2,

    },
    rightArrowStyle: {
        width: 8,
        height: 13,
        marginRight: margin,
        marginLeft: 8,
    },

    itemListViewStyle: {
        flexDirection: 'row',
        height: 45,
        justifyContent: 'space-around',
        alignItems: 'center',
        backgroundColor: 'rgba(244,131,106,1.0)',
    },

    itemStyle: {
        justifyContent: 'center',
        alignItems: 'center',
        width: width / 3 - 1,
    },

    textStyle: {
        fontSize: 13,
        color: 'white',
    }
});