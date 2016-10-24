/**
 * Created by xudosom on 2016/10/20.
 */
import React, {Component} from 'react';

import {
    StyleSheet,
    View,
    Image,
    Text,
    TouchableOpacity
} from 'react-native';

import MineCell from './e.mine.cell';

export default class MineOrderCell extends Component {

    static defaultProps = {
        icon: '',
        title: '',
        subTitle: '',
        height: 44,
        onClick: (index)=> {
        },
        itemDataList: [
            {
                icon: 'order1',
                title: '代付款',
            },
            {
                icon: 'order2',
                title: '待使用',
            },
            {
                icon: 'order3',
                title: '待评价',
            },
            {
                icon: 'order4',
                title: '退款/售后',
            },
        ],
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
            <View style={styles.container}>
                {this.renderOrderCellView()}
                {this.renderItemsView()}
            </View>
        );
    }

    renderOrderCellView() {
        return (
            <MineCell
                icon={this.props.icon}
                title={this.props.title}
                subTitle={this.props.subTitle}
                height={this.props.height}
                onClick={(index)=>this.props.onClick(index)}
            />
        );
    }

    renderItemsView() {
        return (
            <View style={styles.itemsBackViewStyle}>
                {this.renderItemList()}
            </View>
        );
    }

    renderItemList() {
        var itemList = [];
        for (var i = 0; i < this.props.itemDataList.length; i++) {
            let itemIndex = i;
            let itemData = this.props.itemDataList[itemIndex];
            let oneItem =
                <TouchableOpacity key={itemIndex} onPress={()=> {
                    this.props.onClick(itemIndex)
                }}>
                    <View style={styles.oneItemStyle}>
                        <Image source={{uri: itemData.icon}} style={{width: 44, height: 32}}/>
                        <Text style={{fontSize: 12, marginTop: 3, color: '#666666'}}>{itemData.title}</Text>
                    </View>
                </TouchableOpacity>
            itemList.push(oneItem);
        }

        return itemList;
    }

};

const margin = 15;
const styles = StyleSheet.create({
    container: {
        backgroundColor: 'white',
        borderBottomColor: '#eeeeee',
        borderBottomWidth: 0.5,
    },
    itemsBackViewStyle: {
        flexDirection: 'row',
        height: 64,
        justifyContent: 'space-around',
        alignItems: 'center',
    },

    oneItemStyle: {
        alignItems: 'center',
    },
});