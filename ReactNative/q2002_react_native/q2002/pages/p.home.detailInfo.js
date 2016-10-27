/**
 * Created by zhengda on 16/10/26.
 */


import React, {Component} from 'react';
import {
    StyleSheet,
    WebView,
    View,

} from 'react-native';

var DomParser = require('react-native-html-parser').DOMParser;


export default class QMovieInfo extends Component {
    constructor() {
        super();
        this.state = {
            moviesource: 'http://www.q2002.com/play/17325/1/1.html'
        }

    }


// {/*source={{uri: this.props.href}}*/}

    render() {
        console.log(this.props.navigator.props);
        let headers = {
            Referer: 'http://www.q2002.com/play/17325/1/1.html',
        };

        return (
            <View />
        );
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
                let detailDoc = new DomParser().parseFromString(detailData, 'text/html')

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

                let resourceElements = contentElement.getElementsByClassName('panel panel-default resource-list');

                for (var i = 0; i < resourceElements.length; i++) {
                    let resorceIndex = i;
                    let resourceE = resourceElements[resorceIndex];
                    let headerE = resourceE.querySelect('div[class="panel-heading"] strong')[0];
                    let listE = resourceE.getElementsByClassName('li[class="dslist-group-item"] a[href]');

                    let headerTitle = headerE.firstChild.nodeValue;
                    console.log(headerTitle);
                    console.log(listE);

                    var oneResourcList = [];
                    for (var j = 0; j < listE.length; j ++){
                        let oneIndex = j;
                        let oneResourceE = listE[oneIndex];
                        console.log(oneResourceE);

                    }

                }

                containerInfo.title = title;
                containerInfo.info = detailInfoArr;
                containerInfo.sumary = sumaryValue;

                // console.log(containerInfo);

            })
            .catch((error)=> {
                alert(error);
            })
    }
}


const styles = StyleSheet.create({
    webView: {
        flex: 1,
    }
});