/**
 * Created by zhengda on 16/10/26.
 */


import React, {Component} from 'react';
import {
    StyleSheet,
    WebView,
    View,

} from 'react-native';

export default class QWebView extends Component {


    render() {
        console.log(this.props.navigator.props);
        let headers = {
            Referer: 'http://www.q2002.com/play/17325/1/1.html',
        };

        return (
            <WebView
                source={{uri: this.state.moviesource, headers: headers}}
                automaticallyAdjustContentInsets={false}
                style={styles.webView}
                javaScriptEnabled={true}
                domStorageEnabled={true}
                decelerationRate="normal"
                startInLoadingState={true}
            />
        );
    }


    componentDidMount() {
        let url = 'http://www.q2002.com/play/17325/1/1.html';
        fetch(url, {
            headers: {
                Referer: 'http://www.q2002.com/play/17340.html',
            }
        })
            .then((response)=> {
                // console.log(response.text());
                return response.text();
            })
            .then((data)=> {
                console.log('开始解析');
                let doc = new DomParser().parseFromString(data, 'text/html')
                console.log('解析完成');

                let playerNode = doc.querySelect('iframe[src]')[0];


                let src = playerNode.getAttribute('src');

                console.log(src);


                this.setState({
                    moviesource: src
                });
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