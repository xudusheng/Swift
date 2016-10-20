/**
 * Created by zhengda on 16/10/19.
 */
import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    TextInput,
    View,
    Image,
    TouchableOpacity,
    Navigator,
    StatusBar,
} from 'react-native';

import Detail from './e.home.detail'
export default class Home extends Component {

    render() {
        return (
            <View style={styles.container}>

                {this.renderNavigationBar()}

                <TouchableOpacity onPress={()=> {
                    this.pushToDetail()
                }}>
                    <Text>首页</Text>
                </TouchableOpacity>
            </View>
        );
    };

    renderNavigationBar() {
        return (
            <View style={styles.navBarAndStatusBarViewStyle}>
                <View style={styles.navigationBarStyle}>
                    <TouchableOpacity onPress={()=>{this.pushToDetail()}}>
                        <Text style={{color: 'white'}}>广州</Text>
                    </TouchableOpacity>
                    <View style={styles.textInputBackViewStyle}>
                        <TextInput
                            placeholder='输入商家、品类、'
                            style={styles.textInputStyle}
                        />
                    </View>


                    <View style={styles.navRightViewStyle}>
                        <TouchableOpacity onPress={()=>alert('消息中心')}>
                            <Image source={{uri: 'icon_homepage_message'}} style={styles.navRightImageStyle}/>
                        </TouchableOpacity>

                        <TouchableOpacity onPress={()=>alert('扫描二维码')}>
                            <Image source={{uri: 'icon_homepage_scan'}} style={styles.navRightImageStyle}/>
                        </TouchableOpacity>
                    </View>
                </View>
            </View>
        );
    };

    //跳转到下一页
    pushToDetail() {
        this.props.navigator.push({
            component: Detail,
            title: '详情'
        });
    };
}


import Dimensions from 'Dimensions';
let {width, height} = Dimensions.get('window');
let whiteColor = 'white';
const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#F5FCFF',
    },

    //状态栏+导航栏
    navBarAndStatusBarViewStyle: {
        height: 64,
        backgroundColor: 'rgba(255, 96, 0, 1.0)',
    },
    //导航栏
    navigationBarStyle: {
        flex: 1,
        flexDirection: 'row',
        marginTop: 20,
        marginBottom: 0,
        backgroundColor: 'rgba(255, 96, 0, 1.0)',
        justifyContent: 'space-around',
        alignItems: 'center',
    },
    navRightViewStyle: {
        flexDirection: 'row',
        width: 60,
        justifyContent: 'space-between',
    },
    textInputBackViewStyle: {
        width: width * 0.7,
        height: 30,
        backgroundColor: whiteColor,
        borderRadius: 15,
    },
    textInputStyle: {
        flex: 1,
        fontSize: 14,
        marginLeft: 10,
        marginRight: 10
    },

    navRightImageStyle: {
        width: 25,
        height: 25,
    },
});
