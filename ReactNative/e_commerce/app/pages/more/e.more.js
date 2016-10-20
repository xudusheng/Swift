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
import NormalCell from './e.more.cell';

export default class More extends Component {
    static defaultProps = {
        cellDataLis: [
            //第一组数据
            [
                {
                    title: '扫一扫',
                    subTitle: '',
                    showSwitch: false,
                }
            ],
            //第二组数据
            [
                {
                    title: '省流量模式',
                    subTitle: '',
                    showSwitch: true,
                },
                {
                    title: '消息提醒',
                    subTitle: '',
                    showSwitch: false,
                },
                {
                    title: '邀请好友',
                    subTitle: '',
                    showSwitch: false,
                },
                {
                    title: '清除缓存',
                    subTitle: '1.94M',
                    showSwitch: false,
                },
            ],

            //第三组数据
            [
                {
                    title: '意见反馈',
                    subTitle: '',
                    showSwitch: false,
                },
                {
                    title: '问卷调查',
                    subTitle: '',
                    showSwitch: false,
                },
                {
                    title: '支付帮助',
                    subTitle: '',
                    showSwitch: false,
                },
                {
                    title: '网络诊断',
                    subTitle: '',
                    showSwitch: false,
                },
                {
                    title: '关于APP',
                    subTitle: '',
                    showSwitch: false,
                },
                {
                    title: '我要应聘',
                    subTitle: '',
                    showSwitch: false,
                },
            ],


        ],
    };

    render() {
        return (
            <View style={styles.container}>

                <NavigatiowView
                    titleView={()=>this.titleView()}
                    rightView={()=>this.rightView()}
                />
                <ScrollView style={styles.container}>
                    {this.createCells()}
                </ScrollView>
            </View>
        );
    };

    //TODO:导航栏标题
    titleView() {
        return (
            <Text style={{color: 'white', fontSize: 17}}>更多</Text>
        );
    }

    //TODO:导航栏设置按钮
    rightView() {
        return (
            <TouchableOpacity onPress={()=>alert('前往设置页面')}>
                <Image source={{uri: 'icon_mine_setting'}} style={{width: 25, height: 25}}/>
            </TouchableOpacity>
        );
    }

    //TODO:循环创建cell
    createCells() {
        var cellList = [];
        for (var section = 0; section < this.props.cellDataLis.length; section++) {
            let sectionIndex = section;
            let sectionDataList = this.props.cellDataLis[sectionIndex];
            for (var row = 0; row < sectionDataList.length; row++) {
                let rowIndex = row;
                let rowData = sectionDataList[rowIndex];
                let showSwitch = rowData.showSwitch;
                let key = '' + sectionIndex + '' + rowIndex;
                if (showSwitch) {
                    cellList.push(
                        <View key={key} style={{marginTop: rowIndex == 0 ? 15 : 0}}>
                            <NormalCell
                                title={rowData.title}
                                showSwitch={showSwitch}
                                onValueChange={(isOn)=>alert(isOn ? '开关开启' + isOn : '开关关闭' + isOn)}
                            />
                        </View>
                    );
                } else {
                    cellList.push(
                        <TouchableOpacity key={key} onPress={()=>this.selectedCell(sectionIndex, rowIndex)}>
                            <View style={{marginTop: rowIndex == 0 ? 15 : 0}}>
                                <NormalCell
                                    title={rowData.title}
                                    subTitle={rowData.subTitle}
                                />
                            </View>
                        </TouchableOpacity>
                    );
                }
            }
        }
        return cellList;
    }

    //选中cell
    selectedCell(section, row) {
        alert('选中了第' + (section + 1) + '组，第' + (row + 1) + '个cell');
    };
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#eeeeee',
    },
});