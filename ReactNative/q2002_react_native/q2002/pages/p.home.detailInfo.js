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

} from 'react-native';

import * as GlobleConst from './p.const';
import QWebView from './p.home.play'
var DomParser = require('react-native-html-parser').DOMParser;

export default class QMovieInfo extends Component {
    constructor() {
        super();
        this.state = {
            movieDetailInfo: null
        }
    }

    componentDidMount() {
        let href = this.props.movieInfo.href;
        var containerInfo = {};
        fetch(href, {})
            .then((response)=> {
                return response.text();
            })
            .then((detailData)=> {
                console.log('================');
                let detailDoc = new DomParser().parseFromString(detailData, 'text/html');

                let containerElement = detailDoc.getElementsByClassName("container-fluid")[0];
                let contentElement = containerElement.getElementsByClassName('row')[0];

                //获取标题
                let titleNode = contentElement.getElementsByClassName('movie-title')[0];
                let title = titleNode.firstChild.nodeValue;

                //获取影片信息
                let detailInfoElement = contentElement.getElementsByClassName('row')[0];

                let trElements = detailInfoElement.querySelect('div table tr');
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
                    let headerE = resourceE.querySelect('div[class="panel-heading"] strong')[0];
                    let listE = resourceE.querySelect('li[class="dslist-group-item"] a[href]');
                    let helpE = resourceE.getElementsByClassName('panel-footer resource-help')[0];

                    let headerTitle = headerE.firstChild.nodeValue;

                    //集数按钮列表
                    var oneResourcList = [];
                    for (var j = 0; j < listE.length; j++) {
                        let oneIndex = j;
                        let oneResourceE = listE[oneIndex];
                        // console.log(oneResourceE);
                        let href = oneResourceE.getAttribute('href');
                        let btnTitle = oneResourceE.firstChild.nodeValue;
                        oneResourcList.push({
                            title: btnTitle,
                            href: GlobleConst.FetchURL + href,
                        });
                    }

                    console.log(helpE.getElementsByTagName('strong')[0].firstChild.nodeValue);
                    var helpContent = helpE.childNodes.toString();
                    helpContent = helpContent.replace('<strong>', '');
                    helpContent = helpContent.replace('</strong>', '');
                    helpContent = helpContent.replace(/<br\/>/g, '');
                    console.log(helpContent);


                    resourceList.push({
                        headerTitle: headerTitle,
                        sourceList: oneResourcList,
                        footerTitle: helpContent,
                    });
                }

                containerInfo.title = title;
                containerInfo.info = detailInfoArr;
                containerInfo.sumary = sumaryValue;
                containerInfo.resourceList = resourceList;
                console.log(containerInfo);

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
        let detailInfoArr = this.state.movieDetailInfo.detailInfoArr;
        let sumary = this.state.movieDetailInfo.sumary;
        let resourceList = this.state.movieDetailInfo.resourceList;

        let containerView =
            <View style={styles.container}>

                <Text style={styles.titleStyle}>{title}</Text>
                <View style={styles.movieDetailInfoViewStyle}>
                </View>

                <TouchableOpacity onPress={()=>{
                    this.props.navigator.push({
                        component: QWebView,
                    });
                }}>
                    <Text style={styles.sumaryStyle}>{sumary}</Text>
                </TouchableOpacity>

                <View style={styles.resourceListViewStyle}>
                </View>

            </View>

        return containerView;

    }
}


const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    titleStyle: {},

    movieDetailInfoViewStyle: {},
    sumaryStyle: {},
    resourceListViewStyle: {},
});