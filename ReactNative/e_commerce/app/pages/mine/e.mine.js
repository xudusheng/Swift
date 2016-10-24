/**
 * Created by zhengda on 16/10/19.
 */

import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    Image,
    ScrollView,
    TouchableOpacity,

} from 'react-native';

import NavigatiowView from '../../component/e.navigationView';
import MineHeader from './e.mine.header'
import MineCell from './e.mine.cell';
import MineOrderCell from './e.mine.cell.order';


export default class Mine extends Component {
    static defaultProps = {
        cellDataLis: [
            //第一组数据
            [
                {
                    icon: 'collect',
                    title: '我的订单',
                    subTitle: '查看全部订单',
                    cellClass: MineOrderCell,
                }],
            //第二组数据
            [
                {
                    icon: 'draft',
                    title: '小马哥钱包',
                    subTitle: '账户余额:￥100',
                    cellClass: MineCell,
                },
                {
                    icon: 'like',
                    title: '抵用券',
                    subTitle: '0',
                    cellClass: MineCell,
                },
            ],
            //第三组数据
            [
                {
                    icon: 'card',
                    title: '积分商城',
                    subTitle: '',
                    cellClass: MineCell,
                },],
            [
                {
                    icon: 'new_friend',
                    title: '今日推荐',
                    subTitle: 'new',
                    cellClass: MineCell,
                },],
            [{
                icon: 'pay',
                title: '我要合作',
                subTitle: '轻松开店，招财进宝',
                cellClass: MineCell,
            },],
        ]
    };

    render() {
        return (
            <View style={styles.container}>
                <ScrollView>
                    <MineHeader
                        onClick={()=>alert('请前往个人中心设置')}
                    />
                    {this.renderCellView()}
                </ScrollView>
            </View>
        );
    }


//TODO:创建Cell_UI
    renderCellView() {
        var cellList = [];
        for (var section = 0; section < this.props.cellDataLis.length; section++) {
            let sectionIndex = section;
            let sectionData = this.props.cellDataLis[sectionIndex];
            for (var row = 0; row < sectionData.length; row++) {
                let rowIndex = row;
                let rowData = sectionData[rowIndex];
                let key = '' + sectionIndex + rowIndex;
                let gapTop = (sectionIndex != 0 && rowIndex == 0) ? 10 : 0;
                var CellClass = rowData.cellClass;
                let view =
                    <View key={key} style={{marginTop: gapTop}}>
                        <CellClass
                            icon={rowData.icon}
                            title={rowData.title}
                            subTitle={rowData.subTitle}
                            onClick={(index)=> {
                                alert('xcccccccccccccccccc')
                            }}
                        />
                    </View>
                cellList.push(view);
            }
        }
        return cellList;
    }

    onClick(index, sectionindex, rowIndex) {
        alert('index = ' + index + '\nsection = ' + sectionindex + '\nrow = ' + rowIndex);
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#F5FCFF',
    },
});