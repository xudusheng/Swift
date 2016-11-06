/**
 * Created by zhengda on 16/11/06.
 */

import React, {Component} from 'react';
import {
    StyleSheet,
    View,
    Text,
    Image,
    TouchableOpacity,
    ScrollView,
    TextInput,
    ListView,
    RecyclerViewBackedScrollView,
} from 'react-native';

import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import * as movieCreators from '../actions/movie';

import * as GlobleConst from './p.const';
import NavigatiowView from '../component/navigationbar'
import QMovieInfo from './q.home.detailInfo';


let searchText = '';
let searchingText = '';
class QSearchView extends Component {
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
    }

    //TODO:网络请求
    componentDidMount() {

    }

    render() {
        return (
            <View style={styles.container}>
                <NavigatiowView
                    titleView={()=>this.titleView()}
                    rightView={()=>this.rightView()}
                />
                {this.configContentView()}
            </View>
        );

    }

    configContentView() {
        let searchTypeId = GlobleConst.SearchTypeId;
        let movie = this.props.movie;
        let movieData = movie.movieList[searchTypeId];

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
                style={styles.listViewStyle}
                initialListSize={10}
                dataSource={this.state.dataSource.cloneWithRowsAndSections(dataBlob, sectionIDs, rowIDs)}
                renderRow={this.renderRow.bind(this)}
                renderSectionHeader={this.renderSectionHeader.bind(this)}
                contentContainerStyle={styles.listViewContentContainerStyle}
                onEndReached={() => this.onEndReached(nextPage)}
                onEndReachedThreshold={10}
                //onScroll={this.onScroll}
                //renderFooter={this.renderFooter}
                renderScrollComponent={props => <RecyclerViewBackedScrollView {...props} />}
            />;

        return view;
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
            </TouchableOpacity>;
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

    //TODO:导航栏标题
    titleView() {
        return (
            <TextInput
                style={styles.TextInputStyle}
                placeholder="请输入搜索内容"
                textAlign='center'
                onChangeText={(text)=> {
                    searchText = text;
                }}
            />
        );
    }

    //TODO:搜索按钮
    rightView() {
        return (
            <TouchableOpacity onPress={()=>this.beginSearch()}>
                <View style={styles.searchButtonStyle}>
                    <Text style={styles.searchButtonTitleStyle}>搜索</Text>
                </View>
            </TouchableOpacity>
        );
    }

    //TODO:按钮的事件响应
    beginSearch() {
        alert(searchText);
        searchingText = searchText;
        this.props.actions.searchMovieList(searchingText, 1);
    }

    onEndReached(page){
        if(searchingText.length < 1){
            return;
        }
        this.props.actions.searchMovieList(searchingText, page);
    }
}

let col = 3;//列数
let margin_gap = 15;//间距
import Dimensions from 'Dimensions';
let screenWidth = Dimensions.get('window').width;
let cellWidth = (screenWidth - margin_gap * (col + 1)) / col;
let cellHeight = cellWidth / 0.6;
const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: 'white',
    },
    TextInputStyle: {
        fontSize: 16,
        width: 200,
        height: 35,
    },

    searchButtonStyle: {
        justifyContent: 'center',
        alignItems: 'center',
        width: 60,
        height: 30,
    },
    searchButtonTitleStyle: {
        color: 'white',

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

});


//根据全局state返回当前页面所需要的信息,（注意以props的形式传递给当前页面）
//使用：this.props.movie
function mapStateToProps(state) {
    return {
        // movieReducer在reducer/index.js中定义
        movie: state.movieReducer,
    };
}

//返回可以操作store.state的actions,(其实就是我们可以通过actions来调用我们绑定好的一系列方法)
function mapDispatchToProps(dispatch) {
    return {
        actions: bindActionCreators(movieCreators, dispatch)
    };
}

export default connect(mapStateToProps, mapDispatchToProps)(QSearchView);