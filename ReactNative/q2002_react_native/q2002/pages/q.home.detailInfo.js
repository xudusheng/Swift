/**
 * Created by zhengda on 16/10/26.
 */


import React, {Component} from 'react';
import {
    StyleSheet,
    WebView,
    View,
    Text,
    Image,
    TouchableOpacity,
    ScrollView,
} from 'react-native';

import * as GlobleConst from './p.const';
import QWebView from './p.home.play'
import NavigatiowView from '../component/navigationbar'

import QMovieDetailInfoView from './q.home.detail.infoView';
import QMovieSumaryView from './q.home.detail.sumaryView';
import QResourceListView from './q.home.detail.resourceListView';

var DomParser = require('react-native-html-parser').DOMParser;

export default class QMovieInfo extends Component {
    constructor() {
        super();
        this.state = {
            movieDetailInfo: null
        }
    }

    //TODO:网络请求
    componentDidMount() {

        let href = this.props.movieInfo.href;
        var containerInfo = {};
        fetch(href, {})
            .then((response)=> {
                return response.text();
            })
            .then((detailData)=> {
                let detailDoc = new DomParser().parseFromString(detailData, 'text/html');

                let containerElement = detailDoc.getElementsByClassName("container-fluid")[0];
                let contentElement = containerElement.getElementsByClassName('row')[0];

                //获取标题
                let titleNode = contentElement.getElementsByClassName('movie-title')[0];
                let title = titleNode.firstChild.nodeValue;
                //获取标题图片
                let imageNode = contentElement.getElementsByClassName('img-thumbnail')[0];
                let imageHref = imageNode.getAttribute('src')


                //获取影片信息
                let detailInfoElement = contentElement.getElementsByClassName('row')[0];

                let tableE = detailInfoElement.getElementsByTagName('table')[0];
                let trElements = tableE.getElementsByTagName('tr');

                // let trElements = detailInfoElement.querySelect('div tbody tr');
                var detailInfoArr = [];

                for (var i = 0; i < trElements.length; i++) {
                    let trIndex = i;
                    let trElement = trElements[trIndex];

                    let tdElements = trElement.getElementsByTagName('td');

                    let trFirstE = tdElements[0]
                    let trTitleE = trFirstE.getElementsByClassName('info-label')[0];
                    let trContentE = tdElements[1];
                    let titleValue = trTitleE.firstChild.nodeValue
                    let contentValue = trContentE.firstChild.nodeValue;

                    let detailInfo = {title: titleValue, content: contentValue};
                    detailInfoArr.push(detailInfo);
                }


                //获取影片简介
                let summaryE = detailInfoElement.querySelect('p[class="summary"]')[0];
                let sumaryValue = summaryE.firstChild.nodeValue;


                //获取影片集数以及对应的播放地址
                var resourceList = [];
                let resourceElements = contentElement.getElementsByClassName('panel panel-default resource-list');

                for (var i = 0; i < resourceElements.length; i++) {
                    let resorceIndex = i;
                    let resourceE = resourceElements[resorceIndex];
                    let panel_heading = resourceE.getElementsByClassName('panel-heading')[0];
                    let dslist_group = resourceE.getElementsByClassName('dslist-group-item')[0];
                    let panel_footer = resourceE.getElementsByClassName('panel-footer resource-help')[0];


                    let headerE = panel_heading.getElementsByTagName('strong')[0];
                    let headerTitle = headerE.firstChild.nodeValue;


                    //集数按钮列表
                    var oneResourcList = [];
                    let listE = dslist_group.getElementsByTagName('a');


                    for (var j = 0; j < listE.length; j++) {
                        let oneIndex = j;
                        let oneResourceE = listE[oneIndex];
                        let href = oneResourceE.getAttribute('href');
                        let btnTitle = oneResourceE.firstChild.nodeValue;


                        oneResourcList.push({
                            title: btnTitle,
                            href: GlobleConst.FetchURL + href,
                        });
                    }

                    var helpContent = panel_footer.childNodes.toString();
                    helpContent = helpContent.replace('<strong>', '');
                    helpContent = helpContent.replace('</strong>', '');
                    helpContent = helpContent.replace(/<br\/>/g, '');


                    resourceList.push({
                        headerTitle: headerTitle,
                        sourceList: oneResourcList,
                        footerTitle: helpContent,
                    });
                }


                containerInfo.title = title;
                containerInfo.image = imageHref;
                containerInfo.info = detailInfoArr;
                containerInfo.sumary = sumaryValue;
                containerInfo.resourceList = resourceList;

                this.setState({
                    movieDetailInfo: containerInfo
                });

            })
            .catch((error)=> {
                alert(error);
            })
    }

    render() {
        if (this.state.movieDetailInfo) {
            return (
                this.createMovieDetailInfoView()
            );

        } else {
            return (
                <View />
            );
        }
    }


    createMovieDetailInfoView() {
        // movieDetailInfo.title = title;
        // movieDetailInfo.info = detailInfoArr;
        // movieDetailInfo.sumary = sumaryValue;
        // movieDetailInfo.resourceList = resourceList;
        let title = this.state.movieDetailInfo.title;
        let image = this.state.movieDetailInfo.image;
        let detailInfoArr = this.state.movieDetailInfo.info;
        let sumary = this.state.movieDetailInfo.sumary;
        let resourceList = this.state.movieDetailInfo.resourceList;

        let containerView =
            <View style={styles.container}>
                <NavigatiowView
                    titleView={()=>this.titleView()}
                />
                <ScrollView>
                    {/*//TODO:电影信息*/}
                    <QMovieDetailInfoView imageurl={image} title={title} infoList={detailInfoArr}/>

                    {/*//TODO:电影简介*/}
                    <QMovieSumaryView title={title} sumary={sumary}/>

                    {/*//TODO:集数列表*/}
                    <QResourceListView resourceList={resourceList} style={styles.resourceListViewStyle}
                                       onClickButton={(href)=> {
                                           let playInfo = {
                                               href: href,
                                               movieDetailInfo: this.state.movieDetailInfo
                                           };
                                           this.props.navigator.push({
                                               component: QWebView,
                                               passProps: {playInfo},
                                           });
                                       }}/>
                </ScrollView>

            </View>

        return containerView;
    }

    //TODO:导航栏标题
    titleView() {
        return (
            <Text style={{color: 'white', fontSize: 16}}>{this.props.movieInfo.title}</Text>
        );
    }


}


const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: 'white',
    },
    titleStyle: {},

    movieDetailInfoViewStyle: {},
    sumaryStyle: {},
    resourceListViewStyle: {},
});