/**
 * Created by Hmily on 2016/11/26.
 */

import React, {Component} from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    ListView,
    RefreshControl,
    RecyclerViewBackedScrollView,
    Navigator,
    TouchableOpacity,
} from 'react-native';

import Load from "react-native-loading-gif";

import ScrollableTabView, {DefaultTabBar} from 'react-native-scrollable-tab-view';
import HTTPUtil from '../../HTTPUtil';
import NewsDetailView from './NewsDetail';
import {COLOR_WHITE, NEWS_ROOT_URL} from '../../const/GlobalConst';

export default class NewsListView extends Component {
    static defaultProps = {
        title: '热点新闻',
    };

    static propTypes = {
        title: React.PropTypes.string,
        onPressLeft: React.PropTypes.func,
        onPressTitle: React.PropTypes.func,
    };

    constructor() {
        super();
        this.state = {
            classify: [],
            isClassifyLoading: true,

            dataSource: new ListView.DataSource({
                rowHasChanged: (row1, row2) => row1 != row2,
            }),
        };
    }

    componentDidMount() {

        this.fetchNewsClassify();
    }

    //TODO:事件
    showDetail() {
        this.props.navigator.push({
            component: View,
            title: '新闻详情',
        })
    }

    //TODO:网络请求
    //TODO:新闻分类信息
    fetchNewsClassify() {
        this.setState({
            isClassifyLoading: true,
        });
        let newsAction = this.props.actions;

        console.log('11111111111111111111');
        this.refs.Load.OpenLoad();//显示HUD
        //为了便于学习，不至于使逻辑混乱，拉取分类的接口不走redux模式
        HTTPUtil.get(NEWS_ROOT_URL)
            .then((json) => {
                this.refs.Load.CloseLoad();
                this.setState({
                    isClassifyLoading: true,
                    classify: json.tngou,
                });

                //拉取新闻列表，走redux模式
                this.state.classify.forEach((oneType) => {
                    let newsID = oneType.id;
                    this.onRefresh(newsID, 1);
                });


            }),
            (error) => {
                this.setState({
                    isClassifyLoading: true,
                });
                this.refs.Load.CloseLoad();
            };
    }

    //TODO:下拉刷新
    onRefresh(id) {
        this.props.actions.fetchNewsList('http://www.tngou.net/api/top/list', id);

    }

    //TODO:上拉刷新
    onEndReached(id, page) {

        this.props.actions.fetchNewsList('http://www.tngou.net/api/top/list', id, page);

    }


//TODO:UI
    scrollableTabContentView() {
        let news = this.props.news;

        var contentViews = [];
        for (var i = 0; i < this.state.classify.length; i++) {
            let typeIndex = i;
            let oneType = this.state.classify[typeIndex];
            let newsID = oneType.id;
            var name = oneType.name;
            name = name.replace(/热点/g, '');

            let currentNews = news.newsArray[newsID];
            let oneView =
                <ListView
                    key={typeIndex}
                    tabLabel={name}
                    style={styles.listViewStyle}
                    initialListSize={10}
                    dataSource={this.state.dataSource.cloneWithRows(currentNews===undefined?[]:currentNews)}
                    renderRow={this.renderRow.bind(this)}
                    enableEmptySections={true}
                    onEndReached={() => this.onEndReached(newsID, 2)}
                    onEndReachedThreshold={10}
                    renderScrollComponent={props => <RecyclerViewBackedScrollView {...props} />}
                    refreshControl={
                        <RefreshControl
                            refreshing={news.isRefreshing}
                            onRefresh={() => this.onRefresh(newsID)}
                            title="Loading..."
                            colors={['#ffaa66cc', '#ff00ddff', '#ffffbb33', '#ffff4444']}
                        />
                    }
                />;
            contentViews.push(oneView);
        }
        return contentViews;
    }

    //TODO:Cell
    renderRow(rowData, sectionID, rowID, highlightRow) {
        // count:13
        // description:"记者“潜伏”全国各地多个催债群多日，发现他们用同样的催债攻略，有统一的话术，每次催债前都要“带齐东西”，有文身、戴金项链最好"
        // fcount:0
        // fromname:"海南网"
        // fromurl:"http://www.hinews.cn/news/system/2016/11/23/030842865.shtml"
        // id:14334
        // img:"/top/161123/2499035308f61c79783365c847a238a5.jpg"
        // keywords:"校园贷背后的催客"
        // rcount:0
        // time:1479862894000
        // title:"校园贷背后的催客:带喇叭上门 统一的话术攻略"
        // topclass:5

        // img字段返回的是不完整的图片路径src，
        // 需要在前面添加【http://tnfs.tngou.net/image】或者【http://tnfs.tngou.net/img】
        // 前者可以再图片后面添加宽度和高度，如：http://tnfs.tngou.net/image/top/default.jpg_180x120

        let rootImageUrl = 'http://tnfs.tngou.net/image';
        let img = rootImageUrl + rowData.img;
        let title = rowData.title;
        let time = rowData.time;
        let fromname = rowData.fromname;

        var view =
            <View style={styles.cellContentViewStyle}>

                <Image source={{uri: img}} style={styles.imageStyle}/>
                <View style={styles.textViewStyle}>
                    <Text style={styles.titleStyle}>{title}</Text>
                    <View style={styles.publishViewStyle}>
                        <Text style={styles.publishTextStyle}>发布时间：{time}</Text>
                        <Text style={styles.publishTextStyle}>{fromname}</Text>

                    </View>
                </View>

            </View>

        return view;
    }

    render() {

        return (
            <View style={styles.container}>
                <ScrollableTabView
                    renderTabBar={() =>
                        <DefaultTabBar
                            tabStyle={styles.tab}
                            textStyle={styles.tabText}
                        />
                    }
                    tabBarBackgroundColor="#fcfcfc"
                    tabBarUnderlineStyle={styles.tabBarUnderlineStyle}
                    tabBarActiveTextColor="#3e9ce9"
                    tabBarInactiveTextColor="#aaaaaa"
                >

                    {this.scrollableTabContentView()}

                </ScrollableTabView>

                <Load ref="Load"></Load>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    tab: {
        paddingBottom: 0,
    },
    tabText: {
        fontSize: 16,
    },
    tabBarUnderlineStyle: {
        height: 1.5,
        backgroundColor: '#3e9ce9',
    },

    listViewStyle: {},

    cellContentViewStyle: {
        flexDirection: 'row',
        alignItems: 'center',
    },

    imageStyle: {
        height: 90,
        width: 120,
        margin: 10
    },
    textViewStyle: {
        flex: 1,
        height: 90,
        marginTop: 10,
        marginBottom: 10,
        marginRight: 10,
    },
    titleStyle: {
        flex: 5,
        color: '#222222',
        fontSize: 16,
    },
    publishViewStyle: {
        flex: 1,
        flexDirection: 'row',
        backgroundColor: 'yellow',
        justifyContent: 'space-between',
    },
    publishTextStyle:{
        color: '#666666',
        fontSize: 12,

    },
});
