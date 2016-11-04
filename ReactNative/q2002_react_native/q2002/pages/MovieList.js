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
    Navigator,
    InteractionManager,
    RecyclerViewBackedScrollView,
    RefreshControl,
} from 'react-native';

import QMovieInfo from './q.home.detailInfo';

import NavigatiowView from '../component/navigationbar'
import * as GlobleConst from './p.const';
import ScrollableTabView, {DefaultTabBar} from 'react-native-scrollable-tab-view';

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
        };

        this.typeList = [
            {
                typeId: 0,
                typeName: '推荐',
                typeHref: 'http://www.q2002.com',
            },

            {
                typeId: 1,
                typeName: '电影',
                typeHref: 'http://www.q2002.com/type/1.html',
            },

            {
                typeId: 2,
                typeName: '电视剧',
                typeHref: 'http://www.q2002.com/type/2.html',
            },

            {
                typeId: 7,
                typeName: '动漫',
                typeHref: 'http://www.q2002.com/type/7.html',
            },

            {
                typeId: 6,
                typeName: '音乐',
                typeHref: 'http://www.q2002.com/type/6.html',
            },

            {
                typeId: 4,
                typeName: '综艺',
                typeHref: 'http://www.q2002.com/type/4.html',
            },

            {
                typeId: 19,
                typeName: '写真',
                typeHref: 'http://www.q2002.com/type/19.html',
            },
        ];
    }

    componentDidMount() {
        // let fetchurl = GlobleConst.FetchURL;
        // this.fetchMovieList_home(fetchurl, 0);
        InteractionManager.runAfterInteractions(() => {
            this.typeList.forEach((oneType)=> {
                let typeId = oneType.typeId;
                this.onRefresh(typeId);
            });
        });

    }


    //TODO:UI界面
    render() {
        console.log('xxxxxxxxxxxxxxxxx');

        // {dataBlob: dataBlob, sectionIDs: sectionIDs, rowIDs: rowIDs};

        return (
            <View style={styles.containerStyle}>
                <NavigatiowView
                    titleView={()=>this.titleView()}
                    rightView={()=>this.rightView()}
                />

                <ScrollableTabView
                    renderTabBar={() =>
                        <DefaultTabBar
                            tabStyle={styles.tab}
                            textStyle={styles.tabText}
                        />
                    }
                    tabBarBackgroundColor="#fcfcfc"
                    tabBarUnderlineStyle={styles.tabBarUnderline}
                    tabBarActiveTextColor="#3e9ce9"
                    tabBarInactiveTextColor="#aaaaaa"
                >
                    {this.configContentViews()}

                </ScrollableTabView>


            </View>
        );
    }

    configContentViews() {
        var views = [];
        for (var i = 0; i < this.typeList.length; i++) {
            let viewIndex = i;
            let viewInfo = this.typeList[viewIndex];

            let typeId = viewInfo.typeId;
            let typeHref = viewInfo.typeHref;

            let movie = this.props.movie;
            let movieData = movie.movieList[typeId];

            let nextPage = 1;
            let dataBlob = {};
            let sectionIDs = [];
            let rowIDs = [];
            if (movieData != undefined) {
                nextPage = movieData.nextPage;
                dataBlob = movieData.dataBlob;
                sectionIDs = movieData.sectionIDs;
                rowIDs = movieData.rowIDs;
            }

            let view =
                <ListView
                    key={viewIndex}
                    tabLabel={viewInfo.typeName}
                    style={styles.listViewStyle}
                    initialListSize={10}
                    dataSource={this.state.dataSource.cloneWithRowsAndSections(dataBlob, sectionIDs, rowIDs)}
                    renderRow={this.renderRow.bind(this)}
                    renderSectionHeader={this.renderSectionHeader.bind(this)}
                    contentContainerStyle={styles.listViewContentContainerStyle}
                    onEndReached={() => this.onEndReached(typeId, nextPage)}
                    onEndReachedThreshold={10}
                    //onScroll={this.onScroll}
                    //renderFooter={this.renderFooter}
                    renderScrollComponent={props => <RecyclerViewBackedScrollView {...props} />}
                    refreshControl={
                        <RefreshControl
                            refreshing={movie.isRefreshing}
                            onRefresh={() => this.onRefresh(typeId)}
                            title="Loading..."
                            colors={['#ffaa66cc', '#ff00ddff', '#ffffbb33', '#ffff4444']}
                        />
                    }
                />;
            views.push(view);
        }
        return views;
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
            <View style={[styles.sectionHeaderViewStyle, {height: sectionData.sectionTitle.length ? 30 : 0,}]}>
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

    //TODO:网络请求
    //TODO:下拉刷新
    onRefresh(typeId) {
        this.props.actions.fetchMovieList(typeId, 1);
    }

    //TODO:上拉刷新
    onEndReached(typeId, page) {
        console.log(typeId + ' xxxxx ' + page);
        if (typeId !== 0) {//单个组的时候才存在上拉刷新
            this.props.actions.fetchMovieList(typeId, page);
        }
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


    tab: {
        paddingBottom: 0
    },
    tabText: {
        fontSize: 16
    },
    tabBarUnderline: {
        backgroundColor: '#3e9ce9',
        height: 1.5,
    },
});
