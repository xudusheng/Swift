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

export default class QWebView extends Component {
    static defaultProps = {
        playInfo: {},
    }

    static propTypes = {
        playInfo: React.PropTypes.object.isRequired,
    }


    constructor() {
        super()
        this.state = {
            moviesource: null,
        }
    }

    render() {

        if (this.state.moviesource) {
            let headers = {Referer: this.props.playInfo.href};
            return (
                <WebView
                    source={{uri: this.state.moviesource, headers: headers}}
                    style={styles.webViewStyle}
                    javaScriptEnabled={true}
                    domStorageEnabled={true}
                    decelerationRate="normal"
                    startInLoadingState={true}
                />
            );
        } else {
            return (<View />);
        }

    }


    componentDidMount() {
        let url = this.props.playInfo.href;
        fetch(url)
            .then((response)=> {
                return response.text();
            })
            .then((data)=> {
                console.log('开始解析');
                let doc = new DomParser().parseFromString(data, 'text/html');
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
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    webViewStyle: {
        flex:1,
        backgroundColor: 'yellow'
    },
});