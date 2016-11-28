/**
 * Created by zhengda on 16/10/26.
 */


import React, {Component} from 'react';
import {
    StyleSheet,
    WebView,
    View,

} from 'react-native';


export default class NewsDetailView extends Component {


    constructor() {
        super();

    }

    render() {
        console.log(this.props.newsModel);
        if (this.props.newsModel) {
            return (
                <View style={styles.container}>
                    <WebView
                        source={{uri: this.props.newsModel.fromurl}}
                        style={styles.webViewStyle}
                        javaScriptEnabled={true}
                        domStorageEnabled={true}
                        decelerationRate="normal"
                        startInLoadingState={true}
                    />
                </View>
            );
        } else {
            return (<View />);
        }

    }


    componentDidMount() {

    }
}


const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: 'white',
    },
    webViewStyle: {
        flex: 1,
        backgroundColor: 'yellow'
    },
});