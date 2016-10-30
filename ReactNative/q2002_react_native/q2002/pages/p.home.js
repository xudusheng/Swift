/**
 * Created by zhengda on 16/10/26.
 */

import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    Image,
    ListView,
    TouchableOpacity,
    Navigator
} from 'react-native';

import QMovieInfo from './q.home.detailInfo';

import NavigatiowView from '../component/navigationbar'
import * as GlobleConst from './p.const';

var DomParser = require('react-native-html-parser').DOMParser;


export default class QHome extends Component {

    constructor() {
        super();

        var getSectionDataSource = (dataBlob, sectionID) => {
            return dataBlob[sectionID];
        };
        var getRowDataSource = (dataBlob, sectionID, rowID) => {
            return dataBlob[sectionID + ':' + rowID];
        };

        this.state = {
            dataSource: new ListView.DataSource({
                getSectionData: getSectionDataSource,//获取组中的数据
                getRowData: getRowDataSource,//获取行中的数据
                rowHasChanged: (r1, r2) => r1 !== r2,
                sectionHeaderHasChanged: (s1, s2) => s1 != s2,
            }),
        }
    }

    //TODO:网络请求
    componentDidMount() {
        let fetchurl = GlobleConst.FetchURL;
        fetch(fetchurl, {
            // method: 'GET'
        })
            .then((response)=> {
                // console.log(response.text());
                return response.text();
            })
            .then((data)=> {
                var movieList = [];
                data = data.replace(/&raquo;/g, '');
                data = data.replace(/<\/footer><\/div>/g, '<\/footer>');
                console.log('开始解析');
                let doc = new DomParser().parseFromString(data, 'text/html')
                console.log('解析完成');

                //定义一下变量
                var dataBlob = {},
                    sectionIDs = [],
                    rowIDs = [];

                let movie_sections = doc.querySelect('div[class="row"]');
                console.log(movie_sections.length);
                for (var section = 0; section < movie_sections.length; section++) {
                    let sectionIndex = section;
                    let sectionNode = movie_sections[sectionIndex];

                    //获取头信息==>即大的分类信息
                    let sectionHeaderNode = sectionNode.querySelect('span a[href]')[0];
                    let sectionTitle = sectionHeaderNode.getAttribute('title');
                    let sectionHref = sectionHeaderNode.getAttribute('href');
                    let sectionSubTitle = sectionHeaderNode.firstChild.nodeValue;
                    let sectionInfo = {
                        sectionTitle: sectionTitle,
                        sectionSubTitle: sectionSubTitle,
                        sectionHref: fetchurl + sectionHref
                    };

                    //1、把组号放入sectionIDs数组中
                    sectionIDs.push(sectionIndex);

                    //2、把表头数据放入sectionInfo中
                    dataBlob[sectionIndex] = sectionInfo;

                    let movie_rows = sectionNode.getElementsByClassName('movie-item');

                    var rowIdsInCurrentSection = [];

                    for (var row = 0; row < movie_rows.length; row++) {
                        let rowIndex = row;
                        let rowElement = movie_rows[rowIndex];

                        let aNode = rowElement.querySelect('a[href]')[0];
                        let imageNode = aNode.querySelect('img')[0];
                        let buttonNode = aNode.querySelect('button[class="hdtag"]')[0];
                        let updateNode = rowElement.querySelect('span')[0];

                        let title = aNode.getAttribute('title');
                        let href = fetchurl + aNode.getAttribute('href');
                        let imageurl = imageNode.getAttribute('src');
                        let updateDate = updateNode.firstChild.nodeValue;
                        let markTitle = buttonNode.firstChild.nodeValue;

                        let oneItemInfo = {
                            title: title,
                            href: href,
                            imageurl: imageurl,
                            updateDate: updateDate,
                            markTitle: markTitle
                        };

                        //把行号放入rowIdsInCurrentSection
                        rowIdsInCurrentSection.push(rowIndex);
                        dataBlob[sectionIndex + ':' + rowIndex] = oneItemInfo;

                        movieList.push(oneItemInfo);
                    }
                    rowIDs.push(rowIdsInCurrentSection);
                }

                //更新状态
                this.setState({
                    dataSource: this.state.dataSource.cloneWithRowsAndSections(dataBlob, sectionIDs, rowIDs),
                });

            })
            .catch((error)=> {
                console.log('error = ' + error);

            });
    }

    //TODO:UI界面
    render() {
        console.log('xxxxxxxxxxxxxxxxx');
        return (
            <View style={styles.containerStyle}>
                <NavigatiowView
                    titleView={()=>this.titleView()}
                    rightView={()=>this.rightView()}
                />
                <ListView
                    style={styles.listViewStyle}
                    dataSource={this.state.dataSource}
                    renderRow={this.renderRow.bind(this)}
                    renderSectionHeader={this.renderSectionHeader.bind(this)}
                    contentContainerStyle={styles.listViewContentContainerStyle}
                />
            </View>
        );
    }

    //TODO:导航栏标题
    titleView() {
        return (
            <Text style={{color: 'white', fontSize: 16}}>推荐</Text>
        );
    }

    //TODO:导航栏设置按钮
    rightView() {
        return (
            <TouchableOpacity onPress={()=>alert('前往设置页面')}>
                <Text style={{color: 'white', fontSize: 16}}>设置</Text>
            </TouchableOpacity>
        );
    }

    //TODO:ListViewCell
    renderRow(rowData, sectionID, rowID, highlightRow) {
        var view =
            <TouchableOpacity
                onPress={()=>this.pressCell(rowData)}
                style={styles.cellContentViewStyle}
            >
                <Image source={{uri: rowData.imageurl}} style={styles.imageStyle}/>
                <View style={styles.textViewStyle}>
                    <Text style={styles.titleStyle}>{rowData.title}</Text>
                    <Text style={styles.moneyStyle}>¥{rowData.updateDate}</Text>
                </View>
            </TouchableOpacity>
        return view;
    }

    //TODO:ListViewHeader
    renderSectionHeader(sectionData, sectionID) {
        console.log(sectionData);
        return (
            <View style={styles.sectionHeaderViewStyle}>
                <Text style={styles.sectionHeaderTitleStyle}>{sectionData.sectionTitle}</Text>
            </View>
        );
    }

    pressCell(rowData) {
        // title: title,
        // href: href,
        // imageurl: imageurl,
        // updateDate: updateDate,
        // markTitle: markTitle

        let movieInfo = rowData;
        this.props.navigator.push({
            component: QMovieInfo,
            title: movieInfo.title,
            passProps: {movieInfo}
        });
    }
}

let col = 3;//列数
let margin_gap = 15;//间距
import Dimensions from 'Dimensions';
let screenWidth = Dimensions.get('window').width;
let cellWidth = (screenWidth - margin_gap * (col + 1)) / col;
let cellHeight = cellWidth / 0.6;
const styles = StyleSheet.create({
    containerStyle: {
        flex: 1,
    },
    listViewStyle: {
        flex: 1,
    },
    listViewContentContainerStyle: {
        flexDirection: 'row',
        flexWrap: 'wrap',
    },
    sectionHeaderViewStyle: {
        backgroundColor: '#eeeeee',
        width: screenWidth,
        height: 30,
        justifyContent: 'center',
    },
    sectionHeaderTitleStyle: {
        marginLeft: margin_gap,
        color: 'red',
    },
    cellContentViewStyle: {
        justifyContent: 'center',
        alignItems: 'center',
        width: cellWidth,
        height: cellHeight,
        marginBottom: 10,
        marginLeft: margin_gap,
    },

    imageStyle: {
        width: cellWidth,
        height: cellHeight,

    },
    textViewStyle: {
        justifyContent: 'center',
        position: 'absolute',
        backgroundColor: 'yellow',
        bottom: 0,
        left: 0,
        right: 0,
    },
    titleStyle: {
        flex: 1,
    },
    moneyStyle: {
        flex: 1,
        color: 'red',
    },
})
