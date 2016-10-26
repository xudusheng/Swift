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
        return (
            <WebView
                source={{uri: this.props.href}}
                ref={this.props.href}
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
        let url = 'http://www.q2002/play/17325/1/1.html'
        fetch(url, {})
            .then((response)=> {
                // console.log(response.text());
                return response.text();
            })
            .then((data)=> {
                console.log(data);
            })
            .catch((error)=>{
                alert(error);
            })
    }
}


const styles = StyleSheet.create({
    webView: {
        flex: 1,
    }
});